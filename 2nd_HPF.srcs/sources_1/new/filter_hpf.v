`timescale 1ns / 1ps
module filter_hpf(
    input clk,
    input rst,
    input signed [15:0] x,
    output signed [15:0] y
    );
    
    // Convert normal scale into 16-Bit scale
    // 2^16=65536 
    // Q-format for 14 fractional bits and 2 integer bits with signed values
    parameter integer a0 = 16384;  // 1.0
    parameter integer a1 = -25575; // -1.5610
    parameter integer a2 = 10509;  // 0.6414
  
    parameter integer b0 = 13117;  // 0.8006
    parameter integer b1 = -26234; // -1.6012
    parameter integer b2 = 13117;  // 0.8006
    
    reg signed [15:0] x_buff_1, x_buff_2;
    reg signed [15:0] y_buff_1, y_buff_2;
    reg signed [31:0] accumulate;
    
    always @(posedge clk) begin
        if (rst)
        begin
             x_buff_1 <= 0;
             x_buff_2 <= 0;
             y_buff_1 <= 0;
             y_buff_2 <= 0;
             accumulate <= 0;
         end
         else begin
            x_buff_2 <= x_buff_1;
            x_buff_1 <= x;
            y_buff_2 <= y_buff_1;
            y_buff_1 <= y;
            accumulate <= (b0 * x) + (b1 * x_buff_1) + (b2 * x_buff_2) + (a1 * y_buff_1) + (a2 * y_buff_2);
        end
    end
    assign y = accumulate[31:16];
endmodule
