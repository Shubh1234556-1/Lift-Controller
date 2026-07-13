`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Dr. Shakuntala Misra National Rehabilitation University, Lucknow
// Student: Shubham Pandey 
// 
// Create Date: 12.07.2026 19:45:48
// Design Name: 
// Module Name: lift_controller
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


module lift_controller(
    input clk, reset,
    input [3:0] floor_req,
    input emergency_stop,
    output reg move_up, move_down, motor_stop,
    output reg [1:0] current_floor
    );

    parameter IDLE       = 2'b00;
    parameter S_MOVE_UP   = 2'b01;
    parameter S_MOVE_DOWN = 2'b10;
    parameter EMERGENCY  = 2'b11;

    reg [1:0] current_state, next_state;
    reg [1:0] target_floor;

    // priority logic 
    always @(*) begin
        target_floor = current_floor;
        if (floor_req[3])
            target_floor = 2'd3;
        else if (floor_req[2])
            target_floor = 2'd2;
        else if (floor_req[1])
            target_floor = 2'd1;
        else if (floor_req[0])
            target_floor = 2'd0;
    end

    // present_state logic 
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // floor tracking logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_floor <= 2'b00;
        else if (current_state == S_MOVE_UP)
            current_floor <= current_floor + 1'b1;
        else if (current_state == S_MOVE_DOWN)
            current_floor <= current_floor - 1'b1;
    end

    // next state logic
    always @(*) begin
        next_state = current_state;

        if (emergency_stop) begin
            next_state = EMERGENCY;
        end
        else begin
            case (current_state)
                IDLE: begin
                    if (target_floor > current_floor)
                        next_state = S_MOVE_UP;
                    else if (target_floor < current_floor)
                        next_state = S_MOVE_DOWN;
                end

                S_MOVE_UP: begin
                    if (current_floor == target_floor)
                        next_state = IDLE;
                    else
                        next_state = S_MOVE_UP;
                end

                S_MOVE_DOWN: begin
                    if (current_floor == target_floor)
                        next_state = IDLE;
                    else
                        next_state = S_MOVE_DOWN;
                end

                EMERGENCY: begin
                    if (!emergency_stop)
                        next_state = IDLE;
                    else
                        next_state = EMERGENCY;
                end

                default: next_state = IDLE;
            endcase
        end
    end

    // output logic
    always @(*) begin
        move_up    = 1'b0;
        move_down  = 1'b0;
        motor_stop = 1'b0;

        case (current_state)
            S_MOVE_UP:   move_up    = 1'b1;
            S_MOVE_DOWN: move_down  = 1'b1;
            EMERGENCY:   motor_stop = 1'b1;
            IDLE:        motor_stop = 1'b1;
            default:     motor_stop = 1'b1;
        endcase
        
        case (target_floor)
            2'd0:    current_floor = 2'd0;
            2'd1:    current_floor = 2'd1;
            2'd2:    current_floor = 2'd2;
            2'd3:    current_floor = 2'd3;
            default: current_floor = 2'd0;
        endcase
        
    end

endmodule