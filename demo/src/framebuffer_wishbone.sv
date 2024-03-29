// simple Wishbone 
// next-cycle turnaround

/* Wishbone Datasheet
General description:    
Supported cycles:       S R/W
Data port, size:        32-bit
Data port, granularity: 32-bit
Data port, max op size: 32-bit
Data transfer ordering: Little-endian
Data transfer seq:      Undefined?
Clock frequency constr: 
Supported signal list:  see interface_wishbone.sv
Special requirements:   
*/

import pkg_dvi::*;
import pkg_mig_framebuffer::*;

module framebuffer_Wishbone #(
    parameter BASE_ADDR = 32'h0000_0000
)(
    Wishbone_intf.S wb,
    MIG_intf.APP    mig_if,
    output          mig_resetn,
    
    output logic    framebuffer_ready,
    input           framebuffer_pull,
    output RGB888_t framebuffer_data,
    output          framebuffer_valid,
    input           clk_dvi

);

    logic [2:0]     addr;
    localparam      ADDR_MASK = 32'd31;
    
    initial begin
        assert ((BASE_ADDR > 0)) else $warning("Using Wishbone base address default of 0");
        assert ((BASE_ADDR & ADDR_MASK) == 0) else $error("Wishbone base address alignment not supported");
    end 
     
    assign addr_match = ((wb.adr & ~ADDR_MASK) == BASE_ADDR);
    assign addr = (wb.adr & ADDR_MASK) >> 2;
    
    logic [3:0] [31:0] pixel_buffer;
    logic       [31:0] pointer_reg;
    logic       [31:0] command_reg;
    localparam          WRITE_PIXELS    = 0;
    localparam          FLIP_BUFFERS    = 4;
    localparam          MIG_ON          = 8;
    logic       [31:0] status_reg;
    localparam          WRITE_ACK       = 0;
    localparam          ACTIVE_BUFFER   = 4;
    localparam          MIG_CAL_DONE    = 8;
    localparam          FIFO_OVERFLOW   = 10;
    localparam          FIFO_UNDERFLOW  = 11;

    assign mig_resetn = command_reg[MIG_ON];

    always_ff @(posedge wb.clk) begin: p_wishbone
        if (wb.rst) begin
            command_reg <= '0;
            wb.data_o   <= '0;
        end else if (wb.stb & addr_match & ~wb.ack) begin
            if (wb.we) begin
                case (addr)
                    0,1,2,3:    pixel_buffer[addr]  <= wb.data_i;
                    4:          pointer_reg         <= wb.data_i;
                    5:          command_reg         <= wb.data_i;
                    default:    ;
                endcase
            end else begin
                case (addr)
                    0,1,2,3:    wb.data_o   <= pixel_buffer[addr];
                    4:          wb.data_o   <= pointer_reg;
                    5:          wb.data_o   <= command_reg;
                    6:          wb.data_o   <= status_reg;
                    default:    wb.data_o   <= '0;
                endcase
            end
        end
        if (wb.rst) begin
            wb.ack <= '0;
        end else if (wb.stb & addr_match & ~wb.ack) begin
            wb.ack <= '1;
        end else begin
            wb.ack <= '0;
        end
    end: p_wishbone
    
    always_comb begin
        wb.err  = '0;
    end

    /////////////////////// Interface CDC ////////////////////////////
    
    // For first pass, rely on "waiting" to CDC pixel_buffer and pointer_reg
    // do timing ignore
    
    logic [31:0] command_reg_mig;
    logic [31:0] status_reg_mig;
    
    xpm_cdc_array_single #(
        .DEST_SYNC_FF(4),   .INIT_SYNC_FF(0),
        .SIM_ASSERT_CHK(0), .SRC_INPUT_REG(0),
        .WIDTH(32)        
    )
    xpm_cdc_array_commandreg (
        .src_clk  (),
        .src_in   (command_reg),
        .dest_clk (mig_if.clk),
        .dest_out (command_reg_mig)
    );
    
    xpm_cdc_array_single #(
        .DEST_SYNC_FF(4),   .INIT_SYNC_FF(0),
        .SIM_ASSERT_CHK(0), .SRC_INPUT_REG(0),
        .WIDTH(32)        
    )
    xpm_cdc_array_statusreg (
        .src_clk  (),
        .src_in   (status_reg_mig),
        .dest_clk (wb.clk),
        .dest_out (status_reg)
    );

    // framebuffer flip must flip only once
    // queue flip on rising edge of command
    // handshake on falling edge
    logic flip_pending;
    logic flip_done;
    logic flipping;
    always @(posedge mig_if.clk) begin
        if (mig_if.rst) begin
            flip_pending    <= '0;
            flip_done       <= '0;
        end else begin
            if (~flip_pending & ~flip_done) begin
                if (command_reg_mig[FLIP_BUFFERS]) begin
                    flip_pending <= '1;
                end
            end else if (flipping) begin
                flip_pending    <= '0;
                flip_done       <= '1;
            end else if (flip_done & ~command_reg_mig[FLIP_BUFFERS]) begin
                flip_done <= '0;
            end
        end
    end
    
    logic write_pending;
    logic writing;
    logic write_done;
        always @(posedge mig_if.clk) begin
        if (mig_if.rst) begin
            write_pending    <= '0;
            write_done       <= '0;
        end else begin
            if (~write_pending & ~write_done) begin
                if (command_reg_mig[WRITE_PIXELS]) begin
                    write_pending <= '1;
                end
            end else if (writing) begin
                write_pending    <= '0;
                write_done       <= '1;
            end else if (write_done & ~command_reg_mig[WRITE_PIXELS]) begin
                write_done <= '0;
            end
        end
    end

    /////////////////////// MIG domain ///////////////////////////////
    
    framebuffer_addr_t read_pointer;
    logic increment_read_pointer;
    logic current_buffer;
    
    always_ff @(posedge mig_if.clk) begin
        if (mig_if.rst) begin
            read_pointer    <= '0;
            current_buffer  <= '0;
            flipping        <= '0;
        end else begin
            flipping        <= '0;
            if (increment_read_pointer) begin
                if  (read_pointer.column==(pkg_dvi::H_ACTIVE-4)) begin
                    if (read_pointer.row==(pkg_dvi::V_ACTIVE-1)) begin
                        read_pointer.row <= '0;
                        read_pointer.column <= '0;
                        if (flip_pending) begin
                            read_pointer.buffer <= ~current_buffer;
                            current_buffer      <= ~current_buffer;
                            flipping            <= '1;
                        end
                    end else begin
                        read_pointer.row <= read_pointer.row + 1;
                    end
                    read_pointer.column <= '0;
                end else begin
                    read_pointer.column <= read_pointer.column + 4;
                end
            end
        end
    end
    
    logic fifo_overflow, fifo_underflow;

    assign status_reg_mig = 32'b0 + 
                            (write_done     << WRITE_ACK) +
                            (current_buffer << ACTIVE_BUFFER) +
                            (mig_if.init_calib_complete << MIG_CAL_DONE) +
                            (fifo_overflow << FIFO_OVERFLOW) +
                            (fifo_underflow << FIFO_UNDERFLOW);
    
    localparam FIFO_WRITE_WIDTH = MIG_DATA_WIDTH; // 128
    localparam FIFO_WRITE_DEPTH = 256;
    localparam FIFO_WRITE_COUNT_WIDTH = 9; // $clog2(FIFO_WRITE_DEPTH); bugged in 2019.2 sim
    localparam FIFO_READ_WIDTH = 32;
    logic [FIFO_WRITE_COUNT_WIDTH-1:0] fifo_write_count;
    
    localparam FIFO_HIGH_FILL = 200;
    localparam FIFO_LOW_FILL = 100;
    
    // write buffer and pointer first, plus
    // command synchronizer path is enough datapath delay by itself
    (* ASYNC_REG = "TRUE" *) logic [127:0] pixel_buffer_cdc;
    (* ASYNC_REG = "TRUE" *) logic [31:0] pointer_reg_cdc;
    always_ff @(posedge mig_if.clk) begin
        if (write_pending) begin
            pixel_buffer_cdc    <= pixel_buffer;
            pointer_reg_cdc     <= pointer_reg;
        end
    end

    logic do_read, do_write;
    always_comb begin: p_mig_control
        do_read = '0;
        do_write = '0;
        if (mig_if.app_rdy) begin
            if (fifo_write_count <= FIFO_LOW_FILL) begin
                do_read = '1;
            end else if (write_pending & mig_if.app_wdf_rdy & ~write_done) begin
                do_write = '1;
            end else if (fifo_write_count <= FIFO_HIGH_FILL) begin
                do_read = '1;
            end
        end
        
        if (do_read) begin
            mig_if.app_en          = '1;
            mig_if.app_addr        = read_pointer;
            mig_if.app_wdf_wren    = '0;
            mig_if.app_cmd         = MIG_CMD_READ;
            increment_read_pointer = '1;
        end else if (do_write) begin
            mig_if.app_en          = '1;
            mig_if.app_addr        = pointer_reg_cdc;
            mig_if.app_wdf_wren    = '1;
            mig_if.app_cmd         = MIG_CMD_WRITE;
            increment_read_pointer = '0;
        end else begin
            mig_if.app_en          = '0;
            mig_if.app_addr        = '0;
            mig_if.app_wdf_wren    = '0;
            mig_if.app_cmd         = MIG_CMD_READ;
            increment_read_pointer = '0;
        end
        mig_if.app_wdf_data = pixel_buffer_cdc;
        mig_if.app_wdf_mask = '1;
        mig_if.app_wdf_end = '1; //only write one at a time in current design
        mig_if.app_ref_req = '0;
        mig_if.app_zq_req  = '0;
        writing = do_write;
    end: p_mig_control
    
    /////////////////// FIFO to pixel clock domain ///////////////
    
// |   Setting USE_ADV_FEATURES[0] to 1 enables overflow flag;     Default value of this bit is 1                        |
// |   Setting USE_ADV_FEATURES[1]  to 1 enables prog_full flag;    Default value of this bit is 1                       |
// |   Setting USE_ADV_FEATURES[2]  to 1 enables wr_data_count;     Default value of this bit is 1                       |
// |   Setting USE_ADV_FEATURES[3]  to 1 enables almost_full flag;  Default value of this bit is 0                       |
// |   Setting USE_ADV_FEATURES[4]  to 1 enables wr_ack flag;       Default value of this bit is 0                       |
// |   Setting USE_ADV_FEATURES[8]  to 1 enables underflow flag;    Default value of this bit is 1                       |
// |   Setting USE_ADV_FEATURES[9]  to 1 enables prog_empty flag;   Default value of this bit is 1                       |
// |   Setting USE_ADV_FEATURES[10] to 1 enables rd_data_count;     Default value of this bit is 1                       |
// |   Setting USE_ADV_FEATURES[11] to 1 enables almost_empty flag; Default value of this bit is 0                       |
// |   Setting USE_ADV_FEATURES[12] to 1 enables data_valid flag;   Default value of this bit is 0  


    localparam FIFO_HIGH_FILL_READ = FIFO_HIGH_FILL*4;
    logic [FIFO_WRITE_COUNT_WIDTH+2-1:0] fifo_read_count;
    logic fifo_resetting_rd;
    always_ff @(posedge clk_dvi) begin: p_startup_ready
        if (fifo_resetting_rd) begin
            framebuffer_ready <= '0;
        end else if (fifo_read_count >= FIFO_HIGH_FILL_READ) begin
            framebuffer_ready <= '1;
        end
    end: p_startup_ready
    
    logic [31:0] fifo_dout;

    xpm_fifo_async #(
        .CDC_SYNC_STAGES(3),
        .DOUT_RESET_VALUE("0"),
        .ECC_MODE("no_ecc"),
        .FIFO_MEMORY_TYPE("block"),
        .FULL_RESET_VALUE(0),
        .PROG_EMPTY_THRESH(10),
        .PROG_FULL_THRESH(10),
        .RD_DATA_COUNT_WIDTH(FIFO_WRITE_COUNT_WIDTH+2),
        .READ_DATA_WIDTH(FIFO_READ_WIDTH),
        .READ_MODE("std"),
        .FIFO_READ_LATENCY(1),
        .RELATED_CLOCKS(0),
        .SIM_ASSERT_CHK(0),
        .USE_ADV_FEATURES("1707"),
        .WAKEUP_TIME(0),
        .WRITE_DATA_WIDTH(FIFO_WRITE_WIDTH),
        .FIFO_WRITE_DEPTH(FIFO_WRITE_DEPTH),
        .WR_DATA_COUNT_WIDTH(FIFO_WRITE_COUNT_WIDTH)
    )
    xpm_fifo_async_inst (
        .almost_empty(), .almost_full(),
        .dbiterr(), .injectdbiterr(),
        .empty(),
        .full(),
        .prog_empty(), .prog_full(),
        .wr_rst_busy(),
        .sbiterr(), .injectsbiterr(),
        .wr_ack(),
        
        .sleep('0),
        .overflow(fifo_overflow), 
        .underflow(fifo_underflow),
        .wr_data_count(fifo_write_count),
        .wr_clk(    mig_if.clk  ),
        .rst(       mig_if.rst  ),
        .wr_en(     mig_if.app_rd_data_valid),
        .din(       mig_if.app_rd_data ),
        
        .rd_clk(    clk_dvi     ),
        .rd_rst_busy(fifo_resetting_rd),
        .rd_data_count(fifo_read_count),
        .rd_en(     framebuffer_pull ),
        .dout(      fifo_dout  ),
        .data_valid(framebuffer_valid )
    );
    
    assign framebuffer_data = fifo_dout[23:0];
    
endmodule: framebuffer_Wishbone
