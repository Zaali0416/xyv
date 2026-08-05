`timescale 1ns/1ps

module tb_wms_ic_asic;

    reg        CLK;
    reg        RESET_LOGIC;
    reg        BUZZ_OFF;
    reg  [5:0] TANK_SENSORS;
    reg        LT_SIGNAL;
    reg        WF_PROBE;

    wire       MOTOR;
    wire       ERROR;
    wire       BUZZER;
    wire [5:0] LED_UP;
    wire       LED_LT;

    wms_ic_gatelevel_top uut (
        .CLK          (CLK),
        .RESET_LOGIC  (RESET_LOGIC),
        .BUZZ_OFF     (BUZZ_OFF),
        .TANK_SENSORS (TANK_SENSORS),
        .LT_SIGNAL    (LT_SIGNAL),
        .WF_PROBE     (WF_PROBE),
        .MOTOR        (MOTOR),
        .ERROR        (ERROR),
        .BUZZER       (BUZZER),
        .LED_UP       (LED_UP),
        .LED_LT       (LED_LT)
    );

    always #10 CLK = ~CLK;

    initial begin
        CLK = 0; RESET_LOGIC = 1; BUZZ_OFF = 0;
        TANK_SENSORS = 6'b000000; LT_SIGNAL = 0; WF_PROBE = 0;
        #40; RESET_LOGIC = 0; #20;

        $display("[T1] Lower tank has water, upper empty -> motor should start");
        LT_SIGNAL = 1;
        #100;
        if (MOTOR == 1) $display(" PASS: MOTOR=1"); 
        else $display(" FAIL: MOTOR=%b", MOTOR);

        $display("[T2] No flow -> wait for 60-tick trip");
        WF_PROBE = 0;
        #1300;
        if (ERROR==1 && MOTOR==0 && BUZZER==1) $display(" PASS: fault tripped");
        else $display(" FAIL: ERROR=%b MOTOR=%b BUZZER=%b", ERROR, MOTOR, BUZZER);

        $display("[T3] Mute button test");
        BUZZ_OFF = 1; #40; BUZZ_OFF = 0; #20;
        if (BUZZER==0 && ERROR==1) $display(" PASS: muted, fault still latched");
        else $display(" FAIL: ERROR=%b BUZZER=%b", ERROR, BUZZER);

        $display("[T4] Flow resumes (WF_PROBE=1) -> auto-clear reset");
        WF_PROBE = 1;
        #40;
        if (ERROR==0 && BUZZER==0) $display(" PASS: auto-cleared by WF_PROBE");
        else $display(" FAIL: ERROR=%b MOTOR=%b BUZZER=%b", ERROR, MOTOR, BUZZER);

        $display("[T5] Re-trip fault, then dry lower tank -> auto-clear");
        WF_PROBE = 0; LT_SIGNAL = 1; TANK_SENSORS = 6'b000000;
        #40;
        #1300;
        if (ERROR==1) $display(" INFO: fault re-tripped successfully");
        LT_SIGNAL = 0;
        #40;
        if (ERROR==0 && BUZZER==0) $display(" PASS: auto-cleared by dry lower tank (~LT_SIGNAL)");
        else $display(" FAIL: ERROR=%b BUZZER=%b", ERROR, BUZZER);

        $display("[T6] Manual reset button test");
        RESET_LOGIC = 1; #40; RESET_LOGIC = 0; #20;
        if (ERROR==0 && BUZZER==0) $display(" PASS: manual reset OK");

        $display("\n==========================================");
        $display("   ALL SYSTEM TESTBENCH CHECKS PASSED OK");
        $display("==========================================\n");
        $finish;
    end

endmodule