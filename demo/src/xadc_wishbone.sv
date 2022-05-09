// simple Wishbone to Xilinx 7-series XADC DRP interface
// blocks bus while transacting
// DRP clock 8-250 MHz
// ADC clock 1-26 MHz
// XADC has 128 16bit registers, 
// map to 32bit boundaries on Wishbone bus, 4 * 128 = 512

// SQRL Acorn, no XADC ext ref
// V_P/V_N are not connected
// LTC3636 temp, 10K:10K divider, to Vaux 14

/* Wishbone Datasheet
General description:    simple Wishbone to Xilinx 7-series XADC DRP interface
Supported cycles:       S R/W; S BLOCK R/W; S RMW
Data port, size:        32-bit (16 used)
Data port, granularity: 32-bit
Data port, max op size: 32-bit
Data transfer ordering: Little-endian
Data transfer seq:      Undefined?
Clock frequency constr: determined by Xilinx 7-series XADC
Supported signal list:  see interface_wishbone.sv
Special requirements:   
*/


module XADC_Wishbone #(
    parameter BASE_ADDR = 32'h0000_0000
)(
    Wishbone_intf.S    wb,
    input   temp_LTC_P, temp_LTC_N,
    output  overtemp,
    output  alarm
);

    localparam ADDR_MASK = 32'd511;
    
    initial begin
        assert ((BASE_ADDR > 0)) else $warning("Using Wishbone base address default of 0");
        assert ((BASE_ADDR & ADDR_MASK) == 0) else $error("Wishbone base address alignment not supported");
    end 
    
    logic [6:0]     DADDR;
    logic [15:0]    DO;
    logic           DEN, DWE, DRDY;
    
    typedef enum {
        sIDLE, sWRITE1,
        sREAD1, sWAIT,
        sACK
    } states_t;
    states_t State, nextState = sIDLE;
    
    always_ff @(posedge wb.clk) begin: pStateUpdater
        if (wb.rst)
            State <= sIDLE;
        else
            State <= nextState;
    end: pStateUpdater
    
    assign addr_match = ((wb.adr & ~ADDR_MASK) == BASE_ADDR);
    assign DADDR = (wb.adr & ADDR_MASK) >> 2;
    
    always_comb begin: pNextStateSel
        nextState = State; //default
        unique case (State)
            sIDLE: begin
                if (wb.stb & addr_match) begin
                    if (wb.we)
                        nextState = sWRITE1;
                    else
                        nextState = sREAD1;
                end
            end
            sWRITE1: begin
                nextState = sWAIT;
            end
            sREAD1: begin
                nextState = sWAIT;
            end
            sWAIT: begin
                if (DRDY)
                    nextState = sACK;
            end
            sACK: begin
                nextState = sIDLE;
            end
        endcase
    end: pNextStateSel
    
    always_comb begin: pStateOutputs
        wb.ack  = '0;
        wb.err  = '0;
        DEN     = '0;
        DWE     = '0;
        unique case (State)
            sIDLE: begin
            end
            sWRITE1: begin
                DEN = '1;
                DWE = '1;
            end
            sREAD1: begin
                DEN = '1;
            end
            sWAIT: begin
            end
            sACK: begin
                wb.ack = '1;
            end
        endcase
    end: pStateOutputs
    
    logic [7:0] xadc_alarm;
    logic [15:0] vaux_p, vaux_n;

    // adapted from UG480
    XADC #(
        // Initializing the XADC Control Registers
        .INIT_40(16'h9000),// Calibration coefficient averaging disabled
                        // averaging of 16 selected for external channels
        .INIT_41(16'h2ef0),// Continuous Sequencer Mode, Disable alarms on Zynq-only stuff,
                        // Enable calibration
        .INIT_42(16'h0400),// Set DCLK divider to 6, ADC = ?Ksps, DCLK = 100MHz
        .INIT_48(16'h4701),// Sequencer channel - enable Temp sensor, VCCINT, VCCAUX,
                        // VCCBRAM, and calibration
        .INIT_49(16'h4000),// Sequencer channel - enable aux analog channel 14
        .INIT_4A(16'h4700),// Averaging enabled for Temp sensor, VCCINT, VCCAUX,
                        // VCCBRAM
        .INIT_4B(16'h4000),// Averaging for external channel 14
        .INIT_4C(16'h0000),// Sequencer Bipolar selection
        .INIT_4D(16'h0000),// Sequencer Bipolar selection
        .INIT_4E(16'h0000),// Sequencer Acq time selection
        .INIT_4F(16'h0000),// Sequencer Acq time selection
        .INIT_50(16'hb5ed),// Temp upper alarm trigger 85°C
        .INIT_51(16'h5999),// Vccint upper alarm limit 1.05V
        .INIT_52(16'hA147),// Vccaux upper alarm limit 1.89V
        .INIT_53(16'hCA33),// OT upper alarm limit 125°C w/ automatic shutdown
        .INIT_54(16'ha93a),// Temp lower alarm reset 60°C
        .INIT_55(16'h5111),// Vccint lower alarm limit 0.95V
        .INIT_56(16'h91Eb),// Vccaux lower alarm limit 1.71V
        .INIT_57(16'hae4e),// OT lower alarm reset 70°C
        .INIT_58(16'h5999),// VCCBRAM upper alarm limit 1.05V
        .INIT_5C(16'h5111),// VCCBRAM lower alarm limit 0.95V
        .SIM_MONITOR_FILE()
    ) xadc_inst (
        .CONVST(    1'b0    ),
        .CONVSTCLK( 1'b0    ),
        .DADDR(     DADDR   ),
        .DCLK(      wb.clk  ),
        .DEN(       DEN     ),
        .DI(        wb.data_i[15:0]),
        .DWE(       DWE     ),
        .RESET(     wb.rst  ),
        .VAUXN(     vaux_n  ),
        .VAUXP(     vaux_p  ),
        .ALM(       xadc_alarm),
        .BUSY(),
        .CHANNEL(),
        .DO(        DO      ),
        .DRDY(      DRDY    ),
        .EOC(),
        .EOS(),
        .JTAGBUSY(),
        .JTAGLOCKED(),
        .JTAGMODIFIED(),
        .OT(        overtemp),
        .MUXADDR(),
        .VP(),
        .VN()
    );
    
    always_ff @(posedge wb.clk) begin
        if (DRDY)
            wb.data_o <= {16'd0, DO};
    end
    
    assign alarm = xadc_alarm[7]; // OR of all others
    assign vaux_p[14] = temp_LTC_P;
    assign vaux_n[14] = temp_LTC_N;
    
endmodule: XADC_Wishbone
