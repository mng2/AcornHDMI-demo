// interface for MIG "native" user interface

interface MIG_intf
#(  parameter DW = 128,
    parameter AW = 30   )
();
    logic           clk, rst;
    logic [AW-1:0]  app_addr;
    logic [2:0]     app_cmd;
    logic           app_en;
    logic [DW-1:0]  app_wdf_data;
    logic [DW/8-1:0]app_wdf_mask;
    logic           app_wdf_end;
    logic           app_wdf_wren;
    logic           app_rd_data;
    logic           app_rd_data_end;
    logic           app_rd_data_valid;
    logic           app_rdy;
    logic           app_wdf_rdy;
    //logic app_sr_req     ('0); //reserved
    //logic app_sr_active  ();
    logic           app_ref_req;
    logic           app_ref_ack;
    logic           app_zq_req;
    logic           app_zq_ack;
    logic           init_calib_complete;
    
    modport MIG (
        input clk, rst,
        input app_addr,
        input app_cmd,
        input app_en,
        input app_wdf_data,
        input app_wdf_end,
        input app_wdf_mask,
        input app_wdf_wren,
        output app_rd_data,
        output app_rd_data_end,
        output app_rd_data_valid,
        output app_rdy,
        output app_wdf_rdy,
        input app_ref_req,
        input app_zq_req,
        output app_ref_ack,
        output app_zq_ack,
        output init_calib_complete
    );
    
    modport APP (
        input   clk, rst,
        output app_addr,
        output app_cmd,
        output app_en,
        output app_wdf_data,
        output app_wdf_end,
        output app_wdf_mask,
        output app_wdf_wren,
        input app_rd_data,
        input app_rd_data_end,
        input app_rd_data_valid,
        input app_rdy,
        input app_wdf_rdy,
        output app_ref_req,
        output app_zq_req,
        input app_ref_ack,
        input app_zq_ack,
        input init_calib_complete
    );

endinterface
