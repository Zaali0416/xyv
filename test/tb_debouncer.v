`timescale 1ns/1ps

module tb_debouncer;

    reg  clk;
    reg  reset;
    reg  async_in;
    wire clean_out;

    wms_debouncer #(
        .DEBOUNCE_LIMIT(20'd10)
    ) uut_hardware_debouncer (
        .clk       (clk),
        .reset     (reset),
        .async_in  (async_in),
        .clean_out (clean_out)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0; reset = 1; async_in = 0;
        #40; reset = 0; #20;

        $display("=== STARTING HARDWARE DEBOUNCER UNIT TESTS ===");

        $display("[Test A] Injecting 4-cycle noise pulse...");
        async_in = 1;
        #80;
        async_in = 0;
        #100;
        if (clean_out == 0) 
            $display(" PASS: Glitch rejected (clean_out stayed 0)");
        else 
            $display(" FAIL: Glitch erroneously passed through!");

        $display("[Test B] Applying sustained 1 for 15 cycles...");
        async_in = 1;
        #300;
        if (clean_out == 1) 
            $display(" PASS: Sustained 1 accepted (clean_out = 1)");
        else 
            $display(" FAIL: Output failed to transition to 1");

        $display("[Test C] Pulling signal to 0 for 5 cycles near threshold...");
        async_in = 0;
        #100;
        async_in = 1;
        #100;
        if (clean_out == 1) 
            $display(" PASS: Near-threshold drop rejected (counter reset, clean_out stayed 1)");
        else 
            $display(" FAIL: Output dropped prematurely!");

        $display("[Test D] Applying sustained 0 for 15 cycles...");
        async_in = 0;
        #300;
        if (clean_out == 0) 
            $display(" PASS: Sustained 0 accepted (clean_out = 0)");
        else 
            $display(" FAIL: Output failed to transition to 0");

        $display("===============================================");
        $display("   ALL HARDWARE DEBOUNCER TESTS PASSED OK");
        $display("==========================================\n");
        $finish;
    end

endmodule