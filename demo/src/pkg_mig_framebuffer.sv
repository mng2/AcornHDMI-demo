
package pkg_mig_framebuffer;

    parameter MIG_ADDR_WIDTH    = 30;
    parameter MIG_DATA_WIDTH    = 128;
    parameter MIG_N_BANKS       = 8;
    parameter MIG_BANK_OFFSET   = 0; // try later?

    parameter MIG_CMD_READ      = 3'b001;
    parameter MIG_CMD_WRITE     = 3'b000;

    typedef struct packed {
        logic [7:0] red, green, blue;
    } RGB888_t;

    // each framebuffer is 2048*2048*32b, 16MB or 24bits of addressing
    parameter PIXEL_BYTES = 4;
    parameter FRAMEBUFFER_WIDTH = 2048;
    parameter FRAMEBUFFER_HEIGHT = 2048;
    parameter FRAMEBUFFER_ROW_OFFSET = 2048*4;
    parameter FRAMEBUFFER_ROW_BITS   = $clog2(FRAMEBUFFER_ROW_OFFSET)-1;
    parameter FRAMEBUFFER_BUFFER_OFFSET = FRAMEBUFFER_ROW_OFFSET*2048;
    parameter BUFFER_0_BASE = 0;
    parameter BUFFER_1_BASE = FRAMEBUFFER_BUFFER_OFFSET;
    
    parameter ADDR_READ_STEP = 16;
    parameter COLUMN_ADDR_MAX = pkg_dvi::H_ACTIVE*4 - ADDR_READ_STEP;
    
    typedef struct packed {
        logic [ MIG_ADDR_WIDTH-1
                -$clog2(FRAMEBUFFER_HEIGHT)-1
                -$clog2(FRAMEBUFFER_WIDTH)-1
                -$clog2(PIXEL_BYTES)-1:0]       buffer;
        logic [$clog2(FRAMEBUFFER_HEIGHT)-1:0]  row;
        logic [$clog2(FRAMEBUFFER_WIDTH)-1:0]   column;
        logic [$clog2(PIXEL_BYTES)-1:0]         pixel_data;
    } framebuffer_addr_t;
    
endpackage
