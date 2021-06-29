`timescale 1ns / 1ps

module NxMQueue_tb();

parameter BITS=3, SIZE=8;
reg CLK, RST, EN;
reg ENQUEUE, DEQUEUE, TOP;
reg [BITS-1:0] DATA_IN;
wire [BITS-1:0] DATA_OUT;
wire OVERFLOW, IS_EMPTY;

NxMQueue #(.BITWIDTH(BITS), .QUEUESIZE(SIZE))
    DUT_NxMQueue(
    .clk            (CLK), 
    .rst            (RST), 
    .enable         (EN),
    .enqueue        (ENQUEUE), 
    .dequeue        (DEQUEUE), 
    .top            (TOP),
    .data_in        (DATA_IN),
    .data_out       (DATA_OUT),
    .queue_overflow (OVERFLOW),
    .queue_is_empty (IS_EMPTY)
    );

task reset();
    RST=1;
    #5 RST=0;
endtask

task enable();
    EN=1;
endtask

task initialize();
    CLK=0;
    RST=0;
    EN=0;
    ENQUEUE=0;
    DEQUEUE=0;
    TOP=0;
    DATA_IN=0;
endtask

task top();
    ENQUEUE=0;
    DEQUEUE=0;
    TOP=1;
endtask

task push();
    ENQUEUE=1;
    DEQUEUE=0;
    TOP=0;
endtask

task pop();
    ENQUEUE=0;
    DEQUEUE=1;
    TOP=0;
endtask

always #5 CLK=~CLK;
initial begin
    initialize();
    #5 reset();
    #5 enable();
    #5;
    /*Push until Stack is Overflow*/
    for(int i=0; i<SIZE; i=i+1) begin
        DATA_IN=i;
        push();
        #10;
    end
    ENQUEUE=0;
    DATA_IN=0;
    /*Top and Pop until Stack is empty*/
    for(int i=0; i<SIZE+1; i=i+1) begin
        #10 top();
        #10 pop();
    end
    $finish;
end
endmodule
