`timescale 1ns / 1ns


module NBitLsbPriorityEncoder_tb();

parameter WIDTH=5;
reg [WIDTH-1:0] interrupts;
wire [$clog2(WIDTH)-1:0] priority_bit;
wire valid;

NBitLsbPriorityEncoder #(.W_DATA(WIDTH))
    DUT_NBitLsbPriorityEncoder(
    .bitline_in     (interrupts),
    .lsb_priority   (priority_bit),
    .available      (valid)
); 

initial begin
    for(int i=0; i<2**WIDTH; i=i+1) begin
        interrupts = i;
        #20;
    end
    $finish;
end
endmodule
