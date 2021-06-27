`timescale 1ns / 1ns


module NBitCcShiftRing #(parameter W_DATA=32)(
    input  wire [W_DATA-1:0] bitline_in,
    output reg [W_DATA-1:0] bitline_out,
    input  wire [$clog2(W_DATA)-1:0] shift_value,
    output reg bitline_valid
    );
    
    reg [$clog2(W_DATA)-1:0] shift_compliment;
    always_comb begin
        shift_compliment = W_DATA-shift_value;
        bitline_out = (bitline_in<<shift_value)|
                      (bitline_in>>shift_compliment);
        bitline_valid = (shift_value>W_DATA)? 1'b0: 1'b1;
    end
endmodule


/*Description*/
/*
NBitCcShiftRing = N Bit Counter clockwise Shift Ring
Objective: shifting the bitline in a circle 
Ex. 10110010 CC Ring Shift by 3 = 10010101
solution: result = (logical Shift left(<<) by x) bitwise or 
(logical shift right(>>) by (number of bits - x) 
10010101 = (10110010<<3)or(10110010>>5) = 10010000 or 00000101

bitline_valid indicates when the data is possible
notice we cant shift a bitline of 5 bits more than 5 
times, otherwise the data is corrupted based on 
this implementation.
*/

/*Questions*/
/*
1. is this function used in the industry? $clog2()
if not, then what is the best way to find the number of bits 
needed to present an integer N 
Ex. an N bit Encoder has N inputs and (ceiling(log_base_2(N))) outputs.   

2. you mentioned not to implement a full adder by gates but use the '+' operator
insted, how can i know or ensure which adder is being implemented?
there are many types of adders and when i code x+y for an n bit
numbers, what is the synthisyzed adder? (carry propagate, carry loockahead or parallel prefix)?
do we have control over which adder is synthisized?
*/

/*acknoledgments*/
/*
 Logical shift right/left <</>> shifts the bus
 and adds zeros from the MSB/LSB side ccordingly to >>/<<.
 Arithmetic shift right/left <<</>>> shifts the bus while
 making sure to compensate for signed numbers.
 Ex. -3 = 3'b101 in 2's-complement,
 by using >> the result is 3'b010.
 by using >>> the result is 3'b110.

*/
