`timescale 1ns/1ps

import pkg_mig_framebuffer::*;

module tb_framebuffer_simple ();

    logic clk = '0;
    always #5 clk <= ~clk;
    logic rst = '1;
    
    // this sim is more about getting the mechanics right than strict accuracy
    // real clk_dvi is 148.5 MHz, call it 7ns
    logic clk_dvi = '0;
    always #3.5 clk_dvi <= ~clk_dvi;
    logic clk_dvi5x = '0;
    always #0.7 clk_dvi5x = ~clk_dvi5x;

    Wishbone_intf wb_neo( .clk, .rst );

    MIG_intf #(.DW(MIG_DATA_WIDTH), .AW(MIG_ADDR_WIDTH) ) 
    mig_if();

    initial begin
        #200;
        @(posedge clk);
        rst <= '0;
    end

    //////////// dutness //////////////

    logic framebuffer_ready, framebuffer_pull, framebuffer_valid;
    RGB888_t framebuffer_data;

    framebuffer_Wishbone #(
        .BASE_ADDR( 32'h4000_0000 )
    ) framebuffer_inst (
        .wb(    wb_neo),
        .mig_if,
        .framebuffer_ready,
        .framebuffer_pull,
        .framebuffer_data,
        .framebuffer_valid,
        .clk_dvi
    );

    logic HDMI_CK_P, HDMI_CK_N,
        HDMI_D0_P, HDMI_D0_N,
        HDMI_D1_P, HDMI_D1_N,
        HDMI_D2_P, HDMI_D2_N;
    
    hdmi_xmitter my_hdmi_xmit(
        .clk_dvi,
        .clk_dvi5x,
        .mmcm_locked(~rst),    
        .framebuffer_ready,
        .framebuffer_pull,
        .framebuffer_data,
        .framebuffer_valid,
        .HDMI_CK_P, .HDMI_CK_N,
        .HDMI_D0_P, .HDMI_D0_N,
        .HDMI_D1_P, .HDMI_D1_N,
        .HDMI_D2_P, .HDMI_D2_N
    );

    ///////////// mig emulation (keep it simple) ///////////////
    
    logic clk_mig = '0;
    always #2.5 clk_mig <= ~clk_mig;
    assign mig_if.clk = clk_mig;
    logic [7:0] wakeup_count;
    always @(posedge mig_if.clk) begin
        mig_if.rst <= rst;
        if (rst) begin
            wakeup_count <= '0;
            mig_if.init_calib_complete <= '0;
        end else begin
            wakeup_count <= wakeup_count + 1;
            if (wakeup_count > 40) begin
                mig_if.init_calib_complete <= '1;
            end
        end
        
    end
    
    logic [MIG_DATA_WIDTH-1:0] emulated_frame_data;
    logic [11:0] [MIG_DATA_WIDTH-1:0] data_pipe;
    logic [11:0]         valid_pipe = '0;
    always @(posedge mig_if.clk) begin
        valid_pipe <= {valid_pipe[10:0], (mig_if.app_rdy & mig_if.app_en & (mig_if.app_cmd==MIG_CMD_READ))};
        data_pipe <= {data_pipe[10:0], emulated_frame_data};
    end
    logic mig_available;
    assign mig_available = ($countones(valid_pipe) < 8);
 
    assign mig_if.app_rdy = mig_if.init_calib_complete & mig_available;
    assign mig_if.app_wdf_rdy = '0;

    framebuffer_addr_t mig_addr;
    always_comb begin
        mig_addr = mig_if.app_addr;
        if ((mig_addr.row==0) && (mig_addr.column==0)) begin
            emulated_frame_data <= {32'h1111_1111, 32'h1111_1111, 32'h1111_1111, 32'hAAAA_AAAA};
        end else if ((mig_addr.column==0)) begin
            emulated_frame_data <= {32'h1111_1111, 32'h1111_1111, 32'h1111_1111, 32'hCCCC_CCCC};
        end else if ((mig_addr.row==(V_ACTIVE-1)) && (mig_addr.column==COLUMN_ADDR_MAX)) begin
            emulated_frame_data <= {32'hFFFF_FFFF, 32'hEEEE_EEEE, 32'hDDDD_DDDD, 32'h3333_3333};
        end else begin
            emulated_frame_data <= {32'd0, 32'd0, 32'd0, 32'd0};
        end
        mig_if.app_rd_data = data_pipe[11];
        mig_if.app_rd_data_valid = valid_pipe[11];
    end
        
endmodule: tb_framebuffer_simple

