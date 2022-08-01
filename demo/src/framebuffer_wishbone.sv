// simple Wishbone 
// blocks bus while transacting

/* Wishbone Datasheet
General description:    
Supported cycles:       S R/W; S BLOCK R/W; S RMW
Data port, size:        32-bit
Data port, granularity: 32-bit
Data port, max op size: 32-bit
Data transfer ordering: Little-endian
Data transfer seq:      Undefined?
Clock frequency constr: 
Supported signal list:  see interface_wishbone.sv
Special requirements:   
*/


module Framebuffer_Wishbone #(
    parameter BASE_ADDR = 32'h0000_0000
)(
    Wishbone_intf.S wb,
    MIG_intf.APP    mig_if,
    
    output logic    framebuffer_ready,
    input           framebuffer_pull,
    output [31:0]   framebuffer_data,
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
    logic       [31:0] status_reg;
    localparam          WRITE_ACK       = 0;
    localparam          CURRENT_BUFFER  = 12;
    localparam          MIG_READY       = 16;
    localparam          MIG_CAL_DONE    = 17;

    always_ff @(posedge wb.clk) begin: p_wishbone
        if (wb.rst) begin
            command_reg <= '0;
        end else if (wb.stb & addr_match) begin
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
        end else begin
            wb.data_o   <= '0;
        end
    end: p_wishbone
    
    always_comb begin
        wb.err  = '0;
        wb.ack  = (wb.stb & addr_match);
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
    logic write_done;

    /////////////////////// MIG domain ///////////////////////////////

    // each framebuffer is 2048*2048*32b, 16MB or 24bits of addressing
    localparam PIXEL_BYTES = 4;
    localparam FRAMEBUFFER_WIDTH = 2048;
    localparam FRAMEBUFFER_HEIGHT = 2048;
    localparam FRAMEBUFFER_ROW_OFFSET = 2048*4;
    localparam FRAMEBUFFER_ROW_BITS   = $clog2(FRAMEBUFFER_ROW_OFFSET)-1;
    localparam FRAMEBUFFER_BUFFER_OFFSET = FRAMEBUFFER_ROW_OFFSET*2048;
    localparam BUFFER_0_BASE = 0;
    localparam BUFFER_1_BASE = FRAMEBUFFER_BUFFER_OFFSET;
    
    localparam ADDR_READ_STEP = 16;
    localparam COLUMN_ADDR_MAX = pkg_dvi::H_ACTIVE*4 - ADDR_READ_STEP;
    localparam MIG_ADDR_WIDTH = 30;
    
    typedef struct packed {
        logic [ MIG_ADDR_WIDTH-1
                -$clog2(FRAMEBUFFER_HEIGHT)-1
                -$clog2(FRAMEBUFFER_WIDTH)-1
                -$clog2(PIXEL_BYTES)-1:0]       buffer;
        logic [$clog2(FRAMEBUFFER_HEIGHT)-1:0]  row;
        logic [$clog2(FRAMEBUFFER_WIDTH)-1:0]   column;
        logic [$clog2(PIXEL_BYTES)-1:0]         pixel_data;
    } read_pointer_t;
    
    read_pointer_t read_pointer;
    logic increment_read_pointer;
    logic current_buffer;
    
    always_ff @(mig_if.clk) begin
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
                end else begin
                    read_pointer.column <= read_pointer.column + 4;
                end
            end
        end
    end
    
    assign status_reg_mig = 32'b0 + 
                            (current_buffer << CURRENT_BUFFER) +
                            (mig_if.app_rdy << MIG_READY) +
                            (mig_if.init_calib_complete << MIG_CAL_DONE);
    
    localparam FIFO_WRITE_WIDTH = 128;
    localparam FIFO_WRITE_DEPTH = 256; // 1 36K BRAM
    localparam FIFO_WRITE_COUNT_WIDTH = $clog2(FIFO_WRITE_DEPTH);
    localparam FIFO_READ_WIDTH = 32;
    logic [FIFO_WRITE_COUNT_WIDTH-1:0] fifo_write_count;
    
    localparam FIFO_HIGH_FILL = 200;
    localparam FIFO_LOW_FILL = 100;
    
    always_ff @(posedge mig_if.clk) begin: p_startup_ready
        if (mig_if.rst) begin
            framebuffer_ready <= '0;
        end else if (fifo_write_count > FIFO_HIGH_FILL) begin
            framebuffer_ready <= '1;
        end
    end: p_startup_ready

    localparam MIG_CMD_READ =   3'b001;
    localparam MIG_CMD_WRITE =  3'b000;
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
            mig_if.app_addr        = pointer_reg; //timing datapath only
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
        mig_if.app_wdf_data = pixel_buffer; //timing datapath only
        mig_if.app_wdf_mask = '1;
        mig_if.app_wdf_end = '1; //only write one at a time in current design
        mig_if.app_ref_req = '0;
        mig_if.app_zq_req  = '0;
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
        .READ_MODE("fwft"),
        .FIFO_READ_LATENCY(0),
        .RELATED_CLOCKS(0),
        .SIM_ASSERT_CHK(0),
        .USE_ADV_FEATURES("0707"),
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
        .overflow(), .underflow(),
        .prog_empty(), .prog_full(),
        .rd_data_count(),
        .rd_rst_busy(), .wr_rst_busy(),
        .sbiterr(), .injectsbiterr(),
        .wr_ack(),
        
        .sleep('0),
        .wr_data_count(fifo_write_count),
        .wr_clk(    mig_if.clk  ),
        .rst(       mig_if.rst  ),
        .wr_en(     mig_if.app_rd_data_valid),
        .din(       mig_if.app_rd_data ),
        
        .rd_clk(    clk_dvi     ),
        .rd_en(     framebuffer_pull ),
        .dout(      framebuffer_data  ),
        .data_valid(framebuffer_valid )
    );
    
endmodule: Framebuffer_Wishbone
