`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.07.2026 23:27:01
// Design Name: 
// Module Name: lift_controller_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////




module lift_controller_tb ();
            
    reg clk ;
    reg reset;
    reg [3:0] floor_req;
    reg emergency_stop;
    wire move_up; 
    wire move_down;
    wire motor_stop;
    wire [1:0] current_floor ;
    
    lift_controller dut ( clk,reset,floor_req,emergency_stop,move_up,move_down,motor_stop,current_floor);
    
    initial
          begin
              {clk,reset,floor_req,emergency_stop} = 0;
          end
    
    always #5 clk = ~clk;
    
    initial 
           begin
               #20;
               reset = 0;
               
               #10;
               floor_req = 4'b0100; //request floor 2
               
               #20;
               floor_req = 4'b0001; // request floor 0
               
               #20;
               floor_req = 4'b1010; // multiple request
               
               #40;
               floor_req = 4'b0000;
               
               //emergency stop
               #20;
               emergency_stop = 1;
               
               #30;
               emergency_stop = 0;
               
               #50;
               $finish;
               
           end
           
endmodule