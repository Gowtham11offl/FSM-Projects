`timescale 1ns/1ps

module tb_washing_machine_controller;

reg clk;
reg rst;
reg start;
reg lid_closed;
reg water_full;
reg wash_done;
reg rinse_done;
reg spin_done;
reg cancel;

wire fill_valve;
wire wash_motor;
wire drain_pump;
wire spin_motor;
wire done;
wire locked;
wire [3:0] state_dbg;

washing_machine_controller dut(
    .clk(clk),
    .rst(rst),
    .start(start),
    .lid_closed(lid_closed),
    .water_full(water_full),
    .wash_done(wash_done),
    .rinse_done(rinse_done),
    .spin_done(spin_done),
    .cancel(cancel),
    .fill_valve(fill_valve),
    .wash_motor(wash_motor),
    .drain_pump(drain_pump),
    .spin_motor(spin_motor),
    .done(done),
    .locked(locked),
    .state_dbg(state_dbg)
);



initial begin
    clk = 0;
    forever #5 clk = ~clk;
end


initial begin

    /*$dumpfile("washing_machine.vcd");
    $dumpvars(0,tb_washing_machine_controller);*/

    
    rst = 1;
    start = 0;
    lid_closed = 0;
    water_full = 0;
    wash_done = 0;
    rinse_done = 0;
    spin_done = 0;
    cancel = 0;

    
    #20; rst = 0;

    #10; lid_closed = 1; 
    
    start = 1;

    #10; start = 0;

    #20; water_full = 1;

    #10; water_full = 0;

    #20; lid_closed = 0;

    #20; lid_closed = 1;

    #30; wash_done = 1;

    #10; wash_done = 0;

    #50; rinse_done = 1;

    #10; rinse_done = 0;

    #50; spin_done = 1;

    #10; spin_done = 0;

    #100;

    $finish;

end

endmodule
