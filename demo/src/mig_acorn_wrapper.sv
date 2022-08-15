
module mig_acorn_wrapper(
    inout [15:0]    ddr3_dq,
    inout [1:0]     ddr3_dqs_n,
    inout [1:0]     ddr3_dqs_p,
    output [15:0]   ddr3_addr,
    output [2:0]    ddr3_ba,
    output          ddr3_ras_n,
    output          ddr3_cas_n,
    output          ddr3_we_n,
    output          ddr3_reset_n,
    output [0:0]    ddr3_ck_p,
    output [0:0]    ddr3_ck_n,
    output [0:0]    ddr3_cke,
    output [1:0]    ddr3_dm,
    output [0:0]    ddr3_odt,
    
    MIG_intf.MIG    mig_if,
    input           clk200,
    input           sys_resetn
);

    mig_7series_0 u_mig_7series_0 (
        .ddr3_addr,
        .ddr3_ba,
        .ddr3_cas_n,
        .ddr3_ck_n,
        .ddr3_ck_p,
        .ddr3_cke,
        .ddr3_ras_n,
        .ddr3_reset_n,
        .ddr3_we_n,
        .ddr3_dq,
        .ddr3_dqs_n,
        .ddr3_dqs_p,
        .ddr3_dm,
        .ddr3_odt,      

        .app_addr                       (mig_if.app_addr),  
        .app_cmd                        (mig_if.app_cmd),  
        .app_en                         (mig_if.app_en),  
        .app_wdf_data                   (mig_if.app_wdf_data),  
        .app_wdf_end                    (mig_if.app_wdf_end),  
        .app_wdf_wren                   (mig_if.app_wdf_wren),  
        .app_wdf_mask                   (mig_if.app_wdf_mask),  
        .app_rd_data                    (mig_if.app_rd_data),  
        .app_rd_data_end                (mig_if.app_rd_data_end),  
        .app_rd_data_valid              (mig_if.app_rd_data_valid),  
        .app_rdy                        (mig_if.app_rdy),  
        .app_wdf_rdy                    (mig_if.app_wdf_rdy),  
        .app_ref_req                    (mig_if.app_ref_req),  
        .app_zq_req                     (mig_if.app_zq_req),  
        .app_ref_ack                    (mig_if.app_ref_ack),  
        .app_zq_ack                     (mig_if.app_zq_ack),  
        .ui_clk                         (mig_if.clk),  
        .ui_clk_sync_rst                (mig_if.rst),  
        .init_calib_complete            (mig_if.init_calib_complete),

        .app_sr_req     ('0), //reserved
        .app_sr_active  (),
        .device_temp    (),
        .sys_clk_i      (clk200),
        .sys_rst        (sys_resetn)
    );

endmodule: mig_acorn_wrapper
