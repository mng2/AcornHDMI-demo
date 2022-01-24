// just a test harness to check that the function works
// converts to tmds then back again
// todo: check control chars and disparity

`timescale 1ns/1ps

`ifdef VERILATOR  // make parameter readable from VPI
  `define VL_RD /*verilator public_flat_rd*/
`else
  `define VL_RD
`endif

module tb_tmds_roundtrip(
    input logic         clk,
    input logic         rst,
    input logic [7:0]   din,
    input logic         validin,
    output logic [7:0]  dout,
    output logic        validout
);

    import pkg_dvi::*;

    tmds_encoded_t encoded = '0;
    tmds_decoded_t decoded = '0;
    logic [2:1] vpipe = '0;

    always_ff @(posedge clk) begin
        if (rst)
            encoded <= '0;
        else begin
            encoded <= tmds_encode(din,'1,'0,encoded.disparity);
                                //data_in,data_en,control,disparity
            vpipe[1] <= validin;
            decoded <= tmds_decode(encoded.tmds_char,vpipe[1]);
                                //data_in,data_active
            vpipe[2] <= vpipe[1];
        end
    end

    assign dout = decoded.databyte;
    assign validout = vpipe[2];

// Dump waves, struct substructure not supported?
`ifndef VERILATOR
  initial begin
    integer idx;
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_tmds_roundtrip);
  end
`endif

endmodule
