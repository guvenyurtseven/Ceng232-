`timescale 1ns / 1ps

module ROM (
input [2:0] addr,
output reg [7:0] dataOut);

	// write your ROM code here
	reg [7:0]	MEMORY [0:7];
    initial begin
    	MEMORY[0] = 8'b00000000;
    	MEMORY[1] = 8'b01010101;
    	MEMORY[2] = 8'b10101010;
    	MEMORY[3] = 8'b00110011;
    	MEMORY[4] = 8'b11001100;
    	MEMORY[5] = 8'b00001111;
    	MEMORY[6] = 8'b11110000;
    	MEMORY[7] = 8'b11111111;
    end
	 always @(*) begin 
        dataOut = MEMORY[addr];
	 end


endmodule

module Difference_RAM (
input mode,
input [2:0] addr,
input [7:0] dataIn,
input [7:0] mask,
input CLK,
output reg [7:0] dataOut);

	// write your XOR_RAM code here
	reg [7:0]	MEMORY [0:7];
	integer i;
	initial begin
		for (i=0; i<8 ; i=i+1) begin
			MEMORY[i] = 0; 
		end
	end

	always @(posedge CLK) begin
		if (mode == 0) begin
			if (dataIn >= mask) begin
				MEMORY[addr] = dataIn - mask;
			end
			else begin
				MEMORY[addr] = mask - dataIn;
			end
		end
	end	
	
	always @(*) begin
		if (mode == 1) begin
			dataOut =	MEMORY[addr];
		end
	end

endmodule


module EncodedMemory (
input mode,
input [2:0] index,
input [7:0] number,
input CLK,
output [7:0] result);

	wire [7:0] mask;

	ROM R(index, mask);
	Difference_RAM DR(mode, index, number, mask, CLK, result);

endmodule


