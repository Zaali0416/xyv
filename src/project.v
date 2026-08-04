`default_nettype none

module tt_um_xyv (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (1 = output, 0 = input)
    input  wire       ena,      // always 1 when the design is powered or selected
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Active-high reset for internal logic (Tiny Tapeout provides active-low rst_n)
    wire reset_logic = ~rst_n;

    // Pin IO Directions
    assign uio_oe[0]   = 1'b0; // Input: BUZZ_OFF
    assign uio_oe[1]   = 1'b1; // Output: ERROR
    assign uio_oe[2]   = 1'b1; // Output: BUZZER
    assign uio_oe[7:3] = 5'b0; // Unused IOs configured as inputs

    // Unused outputs zeroed out
    assign uo_out[7]   = motor_out;
    assign uo_out[6]   = led_lt_out;
    assign uo_out[5:0] = led_up_out[5:0];

    assign uio_out[0]   = 1'b0;
    assign uio_out[1]   = error_out;
    assign uio_out[2]   = buzzer_out;
    assign uio_out[7:3] = 5'b0;

    // Internal wires connecting to design top
    wire       motor_out;
    wire       error_out;
    wire       buzzer_out;
    wire [5:0] led_up_out;
    wire       led_lt_out;

    // Instantiate your main design
    wms_ic_gatelevel_top core_inst (
        .CLK          (clk),
        .RESET_LOGIC  (reset_logic),
        .BUZZ_OFF     (uio_in[0]),
        .TANK_SENSORS (ui_in[5:0]),
        .LT_SIGNAL    (ui_in[6]),
        .WF_PROBE     (ui_in[7]),
        .MOTOR        (motor_out),
        .ERROR        (error_out),
        .BUZZER       (buzzer_out),
        .LED_UP       (led_up_out),
        .LED_LT       (led_lt_out)
    );

    // Suppress unused input warnings
    wire _unused = &{ena, uio_in[7:1], 1'b0};

endmodule
