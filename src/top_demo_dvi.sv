

module top_demo_dvi
(
    input logic         CLK200_P,
    input logic         CLK200_N,
    output logic [4:1]  LEDs_N,
    inout logic         DVI_SDA,
    inout logic         DVI_SCL
);

    logic   clk200;
    logic   clk100;
    logic   clkfb;
    logic   mmcm_lock;
    logic [3:0] uc_gpio;

    IBUFDS #(
        .DIFF_TERM      ("FALSE"),  //has ext term
        .IBUF_LOW_PWR   ("FALSE"),
        .IOSTANDARD     ("DEFAULT")
    ) IBUFDS_clk200 (
      .I    (CLK200_P),
      .IB   (CLK200_N),
      .O    (clk200)
   );
    
    // instantiate MMCM to halve frequency for NEORV32
    MMCME2_BASE #(
        .BANDWIDTH      ("OPTIMIZED"),
        .CLKFBOUT_MULT_F(5.0),
        .CLKFBOUT_PHASE (0.0),
        .CLKIN1_PERIOD  (5.000),
        // CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
        .CLKOUT1_DIVIDE(10),
        .CLKOUT2_DIVIDE(1),
        .CLKOUT3_DIVIDE(1),
        .CLKOUT4_DIVIDE(1),
        .CLKOUT5_DIVIDE(1),
        .CLKOUT6_DIVIDE(1),
        .CLKOUT0_DIVIDE_F(1.0),
        // CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
        .CLKOUT0_DUTY_CYCLE(0.5),
        .CLKOUT1_DUTY_CYCLE(0.5),
        .CLKOUT2_DUTY_CYCLE(0.5),
        .CLKOUT3_DUTY_CYCLE(0.5),
        .CLKOUT4_DUTY_CYCLE(0.5),
        .CLKOUT5_DUTY_CYCLE(0.5),
        .CLKOUT6_DUTY_CYCLE(0.5),
        // CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
        .CLKOUT0_PHASE(0.0),
        .CLKOUT1_PHASE(0.0),
        .CLKOUT2_PHASE(0.0),
        .CLKOUT3_PHASE(0.0),
        .CLKOUT4_PHASE(0.0),
        .CLKOUT5_PHASE(0.0),
        .CLKOUT6_PHASE(0.0),
        .CLKOUT4_CASCADE("FALSE"),
        .DIVCLK_DIVIDE(1),
        .REF_JITTER1(0.0),
        .STARTUP_WAIT("TRUE")
    ) MMCME2_BASE_inst (
        // Clock Outputs: 1-bit (each) output: User configurable clock outputs
        .CLKOUT0    (),
        .CLKOUT0B   (),
        .CLKOUT1    (clk100),
        .CLKOUT1B   (),
        .CLKOUT2    (),
        .CLKOUT2B   (),
        .CLKOUT3    (),
        .CLKOUT3B   (),
        .CLKOUT4    (),
        .CLKOUT5    (),
        .CLKOUT6    (),
        // Feedback Clocks: 1-bit (each) output: Clock feedback ports
        .CLKFBOUT   (clkfb),
        .CLKFBOUTB  (),
        // Status Ports: 1-bit (each) output: MMCM status ports
        .LOCKED     (mmcm_lock),
        // Clock Inputs: 1-bit (each) input: Clock input
        .CLKIN1     (clk200),
        // Control Ports: 1-bit (each) input: MMCM control ports
        .PWRDWN     (1'b0),
        .RST        (1'b0),
        // Feedback Clocks: 1-bit (each) input: Clock feedback ports
        .CLKFBIN    (clkfb)      // 1-bit input: Feedback clock
    );
    
    neorv32_test_setup_approm my_neorv
    (
        .clk_i      (clk100),
        .rstn_i     (mmcm_lock),
        .gpio_o     (uc_gpio),
        .twi_sda_io (DVI_SDA),
        .twi_scl_io (DVI_SCL)
    );
    
    assign LEDs_N = ~uc_gpio;

endmodule // top_demo_dvi
