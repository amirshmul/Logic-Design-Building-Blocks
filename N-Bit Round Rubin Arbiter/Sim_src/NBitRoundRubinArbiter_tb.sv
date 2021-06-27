`timescale 1ns / 1ns

module NBitRoundRubinArbiter_tb();

localparam WIDTH=3;
reg CLK, RST;
reg Acknowledge;
reg [WIDTH-1:0] interrupts;
wire [$clog2(WIDTH)-1:0] curr_priority;


/*Round Rubin Device Under Test instance*/
NBitRoundRubinArbiter #(.BUS_WIDTH(WIDTH))
    DUT_NBitRoundRubinArbiter(
    .clk(CLK),
    .rst(RST),
    .arbitration_ack(Acknowledge),
    .interrupt_bus(interrupts),
    .bus_priority(curr_priority)
    );

task Initialize();
    CLK=0;
    RST=0;
    Acknowledge=0;
    interrupts=0;
endtask

task Reset();
    RST=0;
    #10 RST=1;
    #5  RST=0;
endtask


always #5 CLK=~CLK;
initial begin
    Initialize();
    Reset();
    Acknowledge=1;
    for(int i=0; i<2**WIDTH; i=i+1) begin
        interrupts = i;
        #5;
        //if(i%5==0) Acknowledge=1;
        //else Acknowledge=0;
        #5;
    end
    $finish;
end
endmodule
