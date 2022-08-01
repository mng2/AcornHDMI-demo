
module hdmi_xmitter(
    input           clk_dvi,
    input           clk_dvi5x,
    input           mmcm_locked,
    
    input           framebuffer_ready,
    output          framebuffer_pull,
    input [31:0]    framebuffer_data
    
    output          HDMI_CK_P, HDMI_CK_N,
    output          HDMI_D0_P, HDMI_D0_N,
    output          HDMI_D1_P, HDMI_D1_N,
    output          HDMI_D2_P, HDMI_D2_N
);

    /////////////////// final encode ///////////////////////////
    // blue C0: HSync
    // blue C1: VSync
    // other C's set to zero
    
    logic [$clog2(H_FULL)-1:0]      Hcounter;
    logic [$clog2(V_FULL)-1:0]      Vcounter;
    logic                           active_area;
    logic                           hsync;
    logic                           vsync;
    
    assign active_area = (Hcounter < H_ACTIVE) & (Vcounter < V_ACTIVE);
    assign hsync = (Hcounter >= H_SYNC_START) & (Hcounter < H_SYNC_END);
    assign vsync = (Vcounter >= V_SYNC_START) & (Vcounter < V_SYNC_END);
    
    always_ff @(posedge clk_dvi) begin
        if (xmitter_reset) begin
            Hcounter <= '1;
            Vcounter <= '1;
        end else if (framebuffer_ready) begin
            if (Hcounter >= (H_FULL-1)) begin
                Hcounter <= '0;
            end else begin
                Hcounter <= Hcounter + 1;
            end
            if (Hcounter == (H_FULL-1)) begin
                if (Vcounter >= (V_FULL-1)) begin
                    Vcounter <= '0;
                end else begin
                    Vcounter <= Vcounter + 1;
                end
            end
        end
    end
    
    tmds_encoded_t encoded_red, encoded_green, encoded_blue;
    
    always_ff @(posedge clk_dvi) begin
        if (xmitter_reset) begin
            encoded_red     <= '0;
            encoded_green   <= '0;
            encoded_blue    <= '0;
        end else begin
            encoded_red     <= tmds_encode( .data_in(dai), 
                                            .data_en(active_area), 
                                            .control(2'b0), 
                                            .disparity(encoded_red.disparity) );
            encoded_green   <= tmds_encode( .data_in(dai), 
                                            .data_en(active_area), 
                                            .control(2'b0), 
                                            .disparity(encoded_green.disparity) );
            encoded_blue    <= tmds_encode( .data_in(dai), 
                                            .data_en(active_area), 
                                            .control({vsync, hsync}), 
                                            .disparity(encoded_blue.disparity) );
        end
    end
    
    //////////////// transmitter instantiation /////////////////

    tmds_xmitter #(
        .invert(1'b0)
    ) xmit_clock (
        .clk(clk_dvi), 
        .rst(xmitter_reset),
        .clk5x(clk_dvi5x),
        .datain(10'b1111100000),
        .txp(HDMI_CK_P), .txn(HDMI_CK_N)
    );

    tmds_xmitter #(
        .invert(1'b1)
    ) xmit_data2red (
        .clk(clk_dvi), 
        .rst(xmitter_reset),
        .clk5x(clk_dvi5x),
        .datain(encoded_red.tmds_char),
        .txp(HDMI_D2_N), .txn(HDMI_D2_P)
    );

    tmds_xmitter #(
        .invert(1'b1)
    ) xmit_data1green (
        .clk(clk_dvi), 
        .rst(xmitter_reset),
        .clk5x(clk_dvi5x),
        .datain(encoded_green.tmds_char),
        .txp(HDMI_D1_N), .txn(HDMI_D1_P)
    );
    
    tmds_xmitter #(
        .invert(1'b0)
    ) xmit_data0blue (
        .clk(clk_dvi), 
        .rst(xmitter_reset),
        .clk5x(clk_dvi5x),
        .datain(encoded_blue.tmds_char),
        .txp(HDMI_D0_P), .txn(HDMI_D0_N)
    );

endmodule: hdmi_xmitter
