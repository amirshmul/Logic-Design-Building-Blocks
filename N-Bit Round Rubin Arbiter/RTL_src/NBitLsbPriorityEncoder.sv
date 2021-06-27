`timescale 1ns / 1ns

`define case_generate(INDEX, SIGNAL_IN, SIGNAL_OUT) \
    if(SIGNAL_IN[INDEX]==1'b1) begin                \
        SIGNAL_OUT = INDEX;                         \
    end                                             \

module NBitLsbPriorityEncoder #(parameter W_DATA=32)(
    input wire [W_DATA-1:0] bitline_in,
    output reg [$clog2(W_DATA)-1:0] lsb_priority,
    output reg available
    );
    
    always_comb begin
        available = (bitline_in=={W_DATA{1'b0}})?1'b0: 1'b1;
        lsb_priority={$clog2(W_DATA){1'b0}};
        /*Zero by default
        compensating for lsb_priority='0 case*/
        for(int i=W_DATA; i>0; i=i-1) begin
            `case_generate(i-1, bitline_in, lsb_priority);
        end
    end
endmodule


/*Questions*/
/*
1. which assignment is better or more commonly used
   to set a signal to complete zeros?
    x = {W_DATA{1'b0}} or x = '0 
-> i think on one hand the first is more formal and 
   can be handy on large designs, but the second one
   keeps the code cleaner and more pleasant to read.
   
2. tried using the "priority case" and "priority if"
couldnt find a way to put a for loop inside the
the mentioned blocks, is there any way to construct
a dynamic case block where the number of cases 
and the conditions are parameter dependant?
*/

/*acknoledgments*/
/*
when more than one if statment is active
the last statment is dominant unless
priority is used...
*/