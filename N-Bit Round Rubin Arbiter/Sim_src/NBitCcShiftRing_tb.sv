`timescale 1ns / 1ns


module NBitCcShiftRing_tb();

parameter WIDTH=5;
reg [WIDTH-1:0] data_in;
reg [$clog2(WIDTH)-1:0] Shift_tb;
wire [WIDTH-1:0] data_out;
wire valid_tb;

NBitCcShiftRing #(.W_DATA(WIDTH)) DUT_NBitCcShiftRing(
    .bitline_in(data_in), .shift_value(Shift_tb),
    .bitline_out(data_out), .bitline_valid(valid_tb));

task Initialize();
     data_in='0;
     Shift_tb='0;
endtask

initial begin
    Initialize();
    #20;
    data_in = 8'b10011010;
    for(int i=0; i<=WIDTH+1; i++) begin
        Shift_tb = i;
        #20;
    end
    $finish;
end
endmodule
