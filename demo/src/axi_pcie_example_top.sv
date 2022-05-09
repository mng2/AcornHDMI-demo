
module axi_pcie_example_top #( 
    parameter L = 1
) (
    output  [L-1:0] pci_exp_txp, pci_exp_txn,
    input   [L-1:0] pci_exp_rxp, pci_exp_rxn,
    input           REFCLKp, REFCLKn,
    input           PERSTn,
    output          CLKREQn,
    input           CLK200_P, CLK200_N,
    input           temp_LTC_P, temp_LTC_N,
    output  [4:1]   LEDn,
    output          M2_LEDn
);

    logic           axi_clk_pcie;
    logic           sys_resetn;
    logic           mmcm_lock;
    logic           link_up;
    (* dont_touch="true" *) logic msi_request, msi_grant, msi_enabled;

    logic [7:0]     uart_in_data, uart_out_data;
    logic           uart_in_valid, uart_out_valid;
    logic           uart_interrupt;

    // AXI bus originating from PCIe AXI core
    // 64b data, 32b address
    AXI #(.DW(64)) 
    axi_pcie_if( 
        .aclk(      axi_clk_pcie    ), 
        .aresetn(   sys_resetn      ) 
    );

    axi_pcie_wrapper #(
        .L(L)
    ) my_axi_pcie (
        .pci_exp_txp,
        .pci_exp_txn,
        .pci_exp_rxp,
        .pci_exp_rxn,
        .REFCLKp,
        .REFCLKn,
        .axi_pcie_if,
        .axi_clk_pcie,
        .sys_resetn,
        .mmcm_lock,
        .link_up,
        .msi_request,
        .msi_grant,
        .msi_enabled
    );
    assign M2_LEDn = ~link_up;
    assign CLKREQn = 1'b0; //always request clock

    AXI #(.DW(32)) 
    axi_pcie32_if( 
        .aclk(          axi_clk_pcie    ), 
        .aresetn(       sys_resetn      ) 
    );

    // converts 64b AXI to 32b AXI
    axi_width_change_wrapper
    my_width_change(
        .upstream(      axi_pcie_if     ),
        .downstream32(  axi_pcie32_if   )
    );

    AXI_lite
    axilite_if( 
        .aclk(          axi_clk_pcie    ), 
        .aresetn(       sys_resetn      ) 
    );
    
    axi_to_axilite_wrapper
    my_axi_to_axilite(
        .upstream(      axi_pcie32_if   ),
        .downstream(    axilite_if      )
    );
    
    fake_16550A #(
        .UART_BASE_ADDR(32'h0000_0000   )
    ) my_uart (
        .axilite(       axilite_if      ),
        .databyte_i(    uart_in_data    ),
        .valid_i(       uart_in_valid   ),
        .databyte_o(    uart_out_data   ),
        .valid_o(       uart_out_valid  ),
        .interrupt_flag(uart_interrupt  )
    );
    
    // interrupt handling
    logic uart_interrupt_p;
    logic uart_int_pending;
    logic uart_int_rise, uart_int_fall;
    assign uart_int_rise = ~uart_interrupt_p & uart_interrupt;
    assign uart_int_fall = uart_interrupt_p & ~uart_interrupt;
    always_ff @(posedge axi_clk_pcie) begin
        if (~sys_resetn) begin
            uart_interrupt_p    <= '0;
            msi_request         <= '0;
        end else
            uart_interrupt_p <= uart_interrupt;
        
        if (msi_enabled)
            if (~msi_request) begin
                if (uart_int_rise)
                    msi_request <= '1;
                else if (uart_int_pending) begin
                    msi_request <= '1;
                    uart_int_pending <= '0;
                end
            end else begin
                if (uart_int_rise)
                    uart_int_pending <= '1;
                if (msi_grant)
                    msi_request <= '0;
            end
    end

    // reset needs to be held for 16 cycles after things stabilize
    logic [4:0] reset_counter = '0;
    always_ff @(posedge axi_clk_pcie) begin
        if (!mmcm_lock | !PERSTn)
            reset_counter <= '0;
        else if (reset_counter < 16)
            reset_counter <= reset_counter + 1;
    end
    assign sys_resetn = reset_counter[4];
    
    ////////////////////// NEORV32 /////////////////////////
    
    logic       clk100;
    logic       rst_neorv32;
    logic [7:0] gpio;
    logic [7:0] brt0_txd_o, brt0_rxd_i;
    logic       brt0_txd_valid, brt0_rxd_valid;
    
    Wishbone_intf wb_neo( .clk(clk100), .rst(rst_neorv32) );
    
    neorv32_bootloader_200 myneorv32
    (
        .CLK200_P,
        .CLK200_N,
        .rstn_i(        ~rst_neorv32    ),
        .clk100,
        .gpio_o(        gpio            ),
        .wb_tag_o(      wb_neo.tag),
        .wb_adr_o(      wb_neo.adr),
        .wb_dat_i(      wb_neo.drd),
        .wb_dat_o(      wb_neo.dwr),
        .wb_we_o (      wb_neo.we),
        .wb_sel_o(      wb_neo.sel),
        .wb_stb_o(      wb_neo.stb),
        .wb_cyc_o(      wb_neo.cyc),
        .wb_lock_o(     wb_neo.lock),
        .wb_ack_i(      wb_neo.ack),
        .wb_err_i(      wb_neo.err),
        .brt0_txd_o,
        .brt0_rxd_i,
        .brt0_txd_valid,
        .brt0_rxd_valid
    );
    
    assign LEDn = ~gpio[3:0];

    logic       self_reset_p1;
    (* dont_touch="true" *) logic [3:0] self_reset_shifty = '0;
    always_ff @(posedge clk100) begin: pNeoSelfReset
        self_reset_p1 <= gpio[7];
        if (~self_reset_p1 & gpio[7]) // rising edge detect
            self_reset_shifty <= {self_reset_shifty[2:0], 1'b1};
        else
            self_reset_shifty <= {self_reset_shifty[2:0], 1'b0};
    end: pNeoSelfReset
    assign rst_neorv32 = |self_reset_shifty;

    xpm_cdc_hs_wrap
    xpm_cdc_neo2pcie (
      .dest_out(    uart_in_data    ), 
      .dest_req(    uart_in_valid   ),
      .dest_clk(    axi_clk_pcie    ),
      .src_clk(     clk100          ),
      .src_in(      brt0_txd_o      ),
      .src_send(    brt0_txd_valid  )
    );
   
    xpm_cdc_hs_wrap
    xpm_cdc_pcie2neo (
      .dest_out(    brt0_rxd_i      ), 
      .dest_req(    brt0_rxd_valid  ),
      .dest_clk(    clk100          ),
      .src_clk(     axi_clk_pcie    ),
      .src_in(      uart_out_data   ),
      .src_send(    uart_out_valid  )
    );

    XADC_Wishbone #(
        .BASE_ADDR(32'h4000_0000)
    ) xadc_inst (
        .wb(    wb_neo  ),
        .temp_LTC_P, 
        .temp_LTC_N,
        .overtemp(),
        .alarm()
    );

endmodule: axi_pcie_example_top


module xpm_cdc_hs_wrap #(
    parameter WIDTH = 8
) (
    input               src_clk,
    input               src_send,
    input [WIDTH-1:0]   src_in,
    output              dest_clk,
    output              dest_req,
    output [WIDTH-1:0]  dest_out
);

    logic   src_rcv;
    logic   maintain = '0;

    xpm_cdc_handshake #(
      .DEST_EXT_HSK(0),
      .DEST_SYNC_FF(4),
      .INIT_SYNC_FF(0),
      .SIM_ASSERT_CHK(0),
      .SRC_SYNC_FF(4),
      .WIDTH(WIDTH)
    ) xpm_cdc_hs_inst (
      .dest_out, 
      .dest_req,
      .dest_ack( '0 ),
      .dest_clk,
      .src_rcv,
      .src_clk,
      .src_in,
      .src_send( src_send | maintain )
    );
   
    // need to keep send high until handshake comes back from the other side
    always_ff @(posedge src_clk) begin
        if (src_send)
            maintain <= '1;
        else if (src_rcv)
            maintain <= '0;
    end

endmodule: xpm_cdc_hs_wrap