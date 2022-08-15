// calculate parameters using clock wizard
// but use instantiation instead

module clock_wrapper (
    input       CLK200_P, CLK200_N,
    output      clk200,     // 200 MHz
    output      clk_neo,    // 99 MHz
    output      clk_dvi,    // 148.5 MHz
    output      clk_dvi5x,  // 742.5 MHz
    output      mmcm_locked
);

    logic clk200bufg;
    logic CLKFB;
    logic clk_dvi_int;
    logic clk_dvi5x_int;

    IBUFDS #(
        .DIFF_TERM("FALSE"),       // ext term
        .IBUF_LOW_PWR("FALSE"),    // Low power="TRUE", Highest performance="FALSE" 
        .IOSTANDARD("DEFAULT")     // Specify the input I/O standard
    ) IBUFDS_inst (
        .O(     clk200),
        .I(     CLK200_P),
        .IB(    CLK200_N)
    );

    BUFG BUFG_inst (
        .O(     clk200bufg  ),
        .I(     clk200      )
    );
    
    MMCME2_ADV #(
        .BANDWIDTH("OPTIMIZED"),        // Jitter programming (OPTIMIZED, HIGH, LOW)
        .CLKFBOUT_MULT_F(37.125),          // Multiply value for all CLKOUT (2.000-64.000).
        .CLKFBOUT_PHASE(0.0),           // Phase offset in degrees of CLKFB (-360.000-360.000).
        // CLKIN_PERIOD: Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
        .CLKIN1_PERIOD(5.0),
        .CLKIN2_PERIOD(0.0),
        // CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for CLKOUT (1-128)
        .CLKOUT1_DIVIDE(1),
        .CLKOUT2_DIVIDE(15),
        .CLKOUT3_DIVIDE(1),
        .CLKOUT4_DIVIDE(1),
        .CLKOUT5_DIVIDE(1),
        .CLKOUT6_DIVIDE(1),
        .CLKOUT0_DIVIDE_F(5.0),         // Divide amount for CLKOUT0 (1.000-128.000).
        // CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for CLKOUT outputs (0.01-0.99).
        .CLKOUT0_DUTY_CYCLE(0.5),
        .CLKOUT1_DUTY_CYCLE(0.5),
        .CLKOUT2_DUTY_CYCLE(0.5),
        .CLKOUT3_DUTY_CYCLE(0.5),
        .CLKOUT4_DUTY_CYCLE(0.5),
        .CLKOUT5_DUTY_CYCLE(0.5),
        .CLKOUT6_DUTY_CYCLE(0.5),
        // CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for CLKOUT outputs (-360.000-360.000).
        .CLKOUT0_PHASE(0.0),
        .CLKOUT1_PHASE(0.0),
        .CLKOUT2_PHASE(0.0),
        .CLKOUT3_PHASE(0.0),
        .CLKOUT4_PHASE(0.0),
        .CLKOUT5_PHASE(0.0),
        .CLKOUT6_PHASE(0.0),
        .CLKOUT4_CASCADE("FALSE"),      // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
        .COMPENSATION("ZHOLD"),         // ZHOLD, BUF_IN, EXTERNAL, INTERNAL
        .DIVCLK_DIVIDE(10),              // Master division value (1-106)
        // REF_JITTER: Reference input jitter in UI (0.000-0.999).
        .REF_JITTER1(0.0),
        .REF_JITTER2(0.0),
        .STARTUP_WAIT("FALSE"),         // Delays DONE until MMCM is locked (FALSE, TRUE)
        // Spread Spectrum: Spread Spectrum Attributes
        .SS_EN("FALSE"),                // Enables spread spectrum (FALSE, TRUE)
        .SS_MODE("CENTER_HIGH"),        // CENTER_HIGH, CENTER_LOW, DOWN_HIGH, DOWN_LOW
        .SS_MOD_PERIOD(10000),          // Spread spectrum modulation period (ns) (VALUES)
        // USE_FINE_PS: Fine phase shift enable (TRUE/FALSE)
        .CLKFBOUT_USE_FINE_PS("FALSE"),
        .CLKOUT0_USE_FINE_PS("FALSE"),
        .CLKOUT1_USE_FINE_PS("FALSE"),
        .CLKOUT2_USE_FINE_PS("FALSE"),
        .CLKOUT3_USE_FINE_PS("FALSE"),
        .CLKOUT4_USE_FINE_PS("FALSE"),
        .CLKOUT5_USE_FINE_PS("FALSE"),
        .CLKOUT6_USE_FINE_PS("FALSE")
    )
    MMCME2_ADV_inst (
        // Clock Outputs: 1-bit (each) output: User configurable clock outputs
        .CLKOUT0(clk_dvi_int),           // 1-bit output: CLKOUT0
        .CLKOUT0B(),         // 1-bit output: Inverted CLKOUT0
        .CLKOUT1(clk_dvi5x_int),           // 1-bit output: CLKOUT1
        .CLKOUT1B(),         // 1-bit output: Inverted CLKOUT1
        .CLKOUT2(clk_neo),           // 1-bit output: CLKOUT2
        .CLKOUT2B(),         // 1-bit output: Inverted CLKOUT2
        .CLKOUT3(),           // 1-bit output: CLKOUT3
        .CLKOUT3B(),         // 1-bit output: Inverted CLKOUT3
        .CLKOUT4(),           // 1-bit output: CLKOUT4
        .CLKOUT5(),           // 1-bit output: CLKOUT5
        .CLKOUT6(),           // 1-bit output: CLKOUT6
        // DRP Ports: 16-bit (each) output: Dynamic reconfiguration ports
        .DO(),                     // 16-bit output: DRP data
        .DRDY(),                 // 1-bit output: DRP ready
        // Dynamic Phase Shift Ports: 1-bit (each) output: Ports used for dynamic phase shifting of the outputs
        .PSDONE(),             // 1-bit output: Phase shift done
        // Feedback Clocks: 1-bit (each) output: Clock feedback ports
        .CLKFBOUT(CLKFB),         // 1-bit output: Feedback clock
        .CLKFBOUTB(),       // 1-bit output: Inverted CLKFBOUT
        // Status Ports: 1-bit (each) output: MMCM status ports
        .CLKFBSTOPPED(), // 1-bit output: Feedback clock stopped
        .CLKINSTOPPED(), // 1-bit output: Input clock stopped
        .LOCKED(mmcm_locked),             // 1-bit output: LOCK
        // Clock Inputs: 1-bit (each) input: Clock inputs
        .CLKIN1(clk200bufg),             // 1-bit input: Primary clock
        .CLKIN2(),             // 1-bit input: Secondary clock
        // Control Ports: 1-bit (each) input: MMCM control ports
        .CLKINSEL('1),         // 1-bit input: Clock select, High=CLKIN1 Low=CLKIN2
        .PWRDWN('0),             // 1-bit input: Power-down
        .RST('0),                   // 1-bit input: Reset
        // DRP Ports: 7-bit (each) input: Dynamic reconfiguration ports
        .DADDR('0),               // 7-bit input: DRP address
        .DCLK('0),                 // 1-bit input: DRP clock
        .DEN('0),                   // 1-bit input: DRP enable
        .DI('0),                     // 16-bit input: DRP data
        .DWE('0),                   // 1-bit input: DRP write enable
        // Dynamic Phase Shift Ports: 1-bit (each) input: Ports used for dynamic phase shifting of the outputs
        .PSCLK('0),               // 1-bit input: Phase shift clock
        .PSEN('0),                 // 1-bit input: Phase shift enable
        .PSINCDEC('0),         // 1-bit input: Phase shift increment/decrement
        // Feedback Clocks: 1-bit (each) input: Clock feedback ports
        .CLKFBIN(CLKFB)            // 1-bit input: Feedback clock
    );

    // for OSERDES and transmitter logic
    BUFR #(
        .BUFR_DIVIDE("BYPASS"),
        .SIM_DEVICE("7SERIES")
    )
    BUFR_inst (
        .O(     clk_dvi     ),
        .CE(    '1          ),
        .CLR(   '0          ),
        .I(     clk_dvi_int )
    );
    
    // for OSERDES only
    BUFIO BUFIO_inst (
        .O(     clk_dvi5x   ),
        .I(     clk_dvi5x_int)
    );
   
endmodule: clock_wrapper
    
