// Wishbone b4 out of NEORV32
// no stall/rty

interface Wishbone_intf
#(  parameter DW = 32,
    parameter AW = 32,
    parameter TW = 3    )
(   input clk, 
    input rst           );
    logic [TW-1:0]  tag;
    logic [AW-1:0]  adr;
    logic           stb;
    logic           cyc;
    logic [DW-1:0]  dwr;
    logic [DW-1:0]  drd;
    logic [(DW/8)-1:0] sel;
    logic           we;
    logic           lock;
    logic           ack;
    logic           err;

    modport M (
        output  tag,
        output  adr,
        output  stb,
        output  cyc,
        output  .data_o(dwr),
        input   .data_i(drd),
        output  sel,
        output  we,
        output  lock,
        input   ack,
        input   err
    );
    
    modport S (
        input   clk, rst,
        input   tag,
        input   adr,
        input   stb,
        input   cyc,
        input   .data_i(dwr),
        output  .data_o(drd),
        input   sel,
        input   we,
        input   lock,
        output  ack,
        output  err
    );

endinterface
