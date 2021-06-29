`timescale 1ns / 1ns


module NxMQueue #(parameter BITWIDTH=8, QUEUESIZE=32)(
    input bit clk, rst,
    input wire enable,
    input wire dequeue, enqueue, top,
    input wire [BITWIDTH-1:0] data_in,
    output reg [BITWIDTH-1:0] data_out,
    output reg queue_overflow,
    output reg queue_is_empty
    );

reg operation_valid;  
reg [$clog2(QUEUESIZE):0] queue_count, next_queue_count;
reg [QUEUESIZE-1:0] [BITWIDTH-1:0] queue_registers, next_queue_registers;

always_comb begin
    queue_is_empty = (queue_count=='0) ? 1'b1 : 1'b0;
    queue_overflow = (queue_count==QUEUESIZE) ? 1'b1 : 1'b0;
    operation_valid = (dequeue^enqueue^top)^
                      (dequeue&enqueue&top);
end

always_comb begin
    next_queue_registers = queue_registers;
    next_queue_count = queue_count;
    case({enqueue, dequeue})
        2'b10: begin
            if(~queue_overflow) begin
                next_queue_registers = (queue_registers<<BITWIDTH)|data_in;
                next_queue_count = queue_count+1;
            end
        end
        2'b01: begin
            if(~queue_is_empty) begin
                next_queue_registers = queue_registers;
                next_queue_count = queue_count-1;
            end
        end
        default: begin
            next_queue_registers = queue_registers;
            next_queue_count = queue_count;
        end
    endcase
end
    
always_ff @(posedge clk or negedge rst) begin
    if(rst) begin
        data_out <= '0;
        queue_count <= '0;
        queue_registers <= '0;
    end
    else begin
        /*default assignments*/
        data_out <= data_out;
        queue_count <= queue_count;
        queue_registers <= queue_registers;
        if(operation_valid && enable) begin
            queue_count <= next_queue_count;
            queue_registers <= next_queue_registers;
            data_out <= (top && ~queue_is_empty) ? queue_registers[queue_count-1] : data_out;
        end
    end
end
endmodule
