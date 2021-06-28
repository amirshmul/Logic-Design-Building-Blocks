`timescale 1ns / 1ns


module NxMStack #(parameter BITWIDTH=8, STACKSIZE=32)(
    input bit clk, rst,
    input wire enable,
    input wire push, pop, top,
    input wire [BITWIDTH-1:0] data_in,
    output reg [BITWIDTH-1:0] data_out,
    output reg stack_overflow,
    output reg stack_is_empty
    );

reg [$clog2(STACKSIZE):0] stack_count, next_stack_count; 
reg [STACKSIZE-1:0] [BITWIDTH-1:0] stack_registers, next_stack_registers;
reg operation_valid; 
/*operation_valid is used indicate when none or more
than one operation(push, pop, or top) is requested*/

always_comb begin
    operation_valid = push^pop^top; // active only on single request
    stack_overflow = (stack_count==STACKSIZE) ? 1'b1 : 1'b0;
    stack_is_empty = (stack_count=='0) ? 1'b1 : 1'b0;
    /*if stack_count==0 -> stack is empty,
      if stack_count>STACKSIZE -> stack overflow*/
end

always_comb begin
    /*default assignments*/
    next_stack_count = stack_count;
    next_stack_registers = stack_registers;
    case ({push,pop,top})
        3'b100: begin
            if(~stack_overflow) begin
                next_stack_count = stack_count+1;
                next_stack_registers = (stack_registers<<BITWIDTH)|data_in;
            end
        end
        3'b010: begin
            if(~stack_is_empty)
                next_stack_count = stack_count-1;
                next_stack_registers = stack_registers>>BITWIDTH;
        end
        default: begin
            next_stack_count = stack_count;
            next_stack_registers = stack_registers;
        end
    endcase
end

/*  Asyncroniouse reset block   */
always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        stack_count <= '0;
        stack_registers <= '0;
        data_out <= '0;
    end
    else begin
        /*default assignments*/
        stack_registers <= stack_registers;
        stack_count <= stack_count;
        data_out <= data_out;
        if(operation_valid && enable) begin
            stack_count <= next_stack_count;
            stack_registers <= next_stack_registers;
            data_out <= (top) ? stack_registers[0] : data_out;
        end
    end
end
endmodule


