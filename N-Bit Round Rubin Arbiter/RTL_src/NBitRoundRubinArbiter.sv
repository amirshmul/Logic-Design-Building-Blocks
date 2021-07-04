`timescale 1ns / 1ns


module NBitRoundRubinArbiter #(parameter BUS_WIDTH=32)(
    input bit clk, rst,
    input wire arbitration_ack,
    input wire [BUS_WIDTH-1:0] interrupt_bus,
    output reg [$clog2(BUS_WIDTH)-1:0] bus_priority
    );

reg shift_valid, encoder_valid, valid;
reg [BUS_WIDTH-1:0] shifted_bus;
reg [$clog2(BUS_WIDTH)-1:0] shifted_priority,
                            shift_value,
                            next_priority;
                            
assign valid = shift_valid & encoder_valid;
assign shift_value = (BUS_WIDTH-1)-bus_priority;
assign next_priority = (bus_priority+shifted_priority+1)%BUS_WIDTH;
/*modulo operator is needed for all 
the widths that are not 1,2,4,8,16...*/

/*Cc shift ring instantiation*/
NBitCcShiftRing #(.W_DATA(BUS_WIDTH))
    NBitCcShiftRing_inst(
    .bitline_in     (interrupt_bus),
    .bitline_out    (shifted_bus),
    .shift_value    (shift_value),
    .bitline_valid  (shift_valid)
    );

/*LSB priority encoder instantiation*/
NBitLsbPriorityEncoder #(.W_DATA(BUS_WIDTH)) 
    NBitLsbPriorityEncoder_inst(
    .bitline_in     (shifted_bus),
    .lsb_priority   (shifted_priority),
    .available      (encoder_valid)
    ); 

/*Asyncronouse reset block*/
always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        bus_priority <= '0;
    end
    else begin
        /*hold same value by default*/
        bus_priority <= bus_priority;
        /*if shifter & Encoder have legal
        values and Arbitration Acknowledge
        is active update the next priority*/
        if(valid && arbitration_ack) begin
            bus_priority <= next_priority;
        end 
    end 
end
// Amir: in a register you don't need to write "default" value, if non of the "if" statements holds, no assignment is made, and the FF holds the priovious value.
// I would write:
always_ff @(posedge clk or posedge rst) 
  if (rst)                           bus_priority <= '0;
  else if (valid && arbitration_ack) bus_priority <= next_priority;
    

endmodule

/*Arbitration Acknowledge*/
/*
adding this signal will effect when the 
output priority register "bus_priority"
gets updated, thus the achnowledge siganl 
drives the enable of the D-Flipflops,
once the achnowledge is active the 
next priority is able to propagates into
the output.

// Amir: great! you got it...
*/


