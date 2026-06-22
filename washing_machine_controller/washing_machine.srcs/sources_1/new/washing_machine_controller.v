`timescale 1ns / 1ps



module washing_machine_controller #(
    parameter DRAIN_TICKS = 2,
    parameter DONE_TICKS  = 2
)(

    input wire clk,
    input wire rst,
    input wire start,
    input wire lid_closed,
    input wire water_full,
    input wire wash_done,
    input wire rinse_done,
    input wire spin_done,
    input wire cancel,

    
    output reg  fill_valve,
    output reg  wash_motor,
    output reg  drain_pump,
    output reg  spin_motor,
    output reg  done,
    output reg  locked,
    output reg [3:0] state_dbg
);

   

    localparam [3:0]
        S_IDLE   = 4'd0,       
	S_FILL   = 4'd1,
        S_WASH   = 4'd2,
        S_DRAIN1 = 4'd3,
        S_RINSE  = 4'd4,
        S_DRAIN2 = 4'd5,
        S_SPIN   = 4'd6,
        S_DONE   = 4'd7,
        S_PAUSE  = 4'd8;

   
    reg [3:0] state_q;          
    reg [3:0] resume_state_q;   
    reg [15:0] timer_q;

 
    wire drain_timer_done = (timer_q >= DRAIN_TICKS - 1);
    wire done_timer_done  = (timer_q >= DONE_TICKS  - 1);

   
    wire active_state = (state_q != S_IDLE)  &&
                        (state_q != S_DONE)  &&
                        (state_q != S_PAUSE);

   
  always @(posedge clk) begin
        if (rst) begin
            state_q        <= S_IDLE;
            resume_state_q <= S_IDLE;
            timer_q        <= 16'd0;
        end else begin

          
            if (cancel) begin
                state_q        <= S_IDLE;
                resume_state_q <= S_IDLE;
                timer_q        <= 16'd0;

            
            end else if (!lid_closed && active_state) begin
                resume_state_q <= state_q;
                state_q        <= S_PAUSE;
                timer_q        <= 16'd0;

            end else begin
                case (state_q)

                    
                    S_IDLE: begin
                        timer_q <= 16'd0;
                        if (start && lid_closed)
                            state_q <= S_FILL;
                    end

                    
                    S_FILL: begin
                        timer_q <= 16'd0;
                        if (water_full)
                            state_q <= S_WASH;
                    end

                    
                    S_WASH: begin
                        timer_q <= 16'd0;
                        if (wash_done)
                            state_q <= S_DRAIN1;
                    end

                    
                    S_DRAIN1: begin
                        if (drain_timer_done) begin
                            state_q <= S_RINSE;
                            timer_q <= 16'd0;
                        end else begin
                            timer_q <= timer_q + 16'd1;
                        end
                    end

                    
                    S_RINSE: begin
                        timer_q <= 16'd0;
                        if (rinse_done)
                            state_q <= S_DRAIN2;
                    end

                
                    S_DRAIN2: begin
                        if (drain_timer_done) begin
                            state_q <= S_SPIN;
                            timer_q <= 16'd0;
                        end else begin
                            timer_q <= timer_q + 16'd1;
                        end
                    end

                    
                    S_SPIN: begin
                        timer_q <= 16'd0;
                        if (spin_done)
                            state_q <= S_DONE;
                    end

                    
                    S_DONE: begin
                        if (done_timer_done) begin
                            state_q <= S_IDLE;
                            timer_q <= 16'd0;
                        end else begin
                            timer_q <= timer_q + 16'd1;
                        end
                    end

                    
                    S_PAUSE: begin
                        timer_q <= 16'd0;
                        if (lid_closed)
                            state_q <= resume_state_q;
                    end

                    
                    default: begin
                        state_q <= S_IDLE;
                        timer_q <= 16'd0;
                    end

                endcase
            end
        end
    end

    

    always @(*) begin
        // Default: all off
        fill_valve = 1'b0;
        wash_motor = 1'b0;
        drain_pump = 1'b0;
        spin_motor = 1'b0;
        done       = 1'b0;
        locked     = 1'b0;
        state_dbg  = state_q;

        case (state_q)
            S_IDLE:   begin /* all off */ end
            S_FILL:   begin fill_valve = 1'b1; locked = 1'b1; end
            S_WASH:   begin wash_motor = 1'b1; locked = 1'b1; end
            S_DRAIN1: begin drain_pump = 1'b1; locked = 1'b1; end
            S_RINSE:  begin wash_motor = 1'b1; locked = 1'b1; end
            S_DRAIN2: begin drain_pump = 1'b1; locked = 1'b1; end
            S_SPIN:   begin spin_motor = 1'b1; locked = 1'b1; end
            S_DONE:   begin done = 1'b1; end
            S_PAUSE:  begin 
    end
            default:  begin 
    end
        endcase
    end

endmodule

