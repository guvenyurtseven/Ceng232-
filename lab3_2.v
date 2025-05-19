`timescale 1ns / 1ps
module lab3_2(
			input[5:0] money,
			input CLK,
			input vm, //0:VM0, 1:VM1
			input [2:0] productID, //000:sandwich, 001:chocolate, 11x: dont care
			input sugar, //0: No sugar, 1: With Sugar
			output reg [5:0] moneyLeft,
			output reg [4:0] itemLeft,
			output reg productUnavailable,//1:show warning, 0:do not show warning
			output reg insufficientFund , //1:full, 0:not full
			output reg notExactFund , //1:full, 0:not full
			output reg invalidProduct, //1: empty, 0:not empty
			output reg sugarUnsuitable, //1: empty, 0:not empty
			output reg productReady	//1:door is open, 0:closed
	);

	// Internal State of the Module
	// (you can change this but you probably need this)
	reg [4:0] numOfSandwiches;
	reg [4:0] numOfChocolate;
	reg [4:0] numOfWaterVM1;
	reg [4:0] numOfWaterVM2;
	reg [4:0] numOfCoffee;
	reg [4:0] numOfTea;

	initial
	begin
		numOfSandwiches=5'b01010;
	 	numOfChocolate=5'b01010;
	 	numOfWaterVM1=5'b00101;
	 	numOfWaterVM2=5'b01010;
	 	numOfCoffee=5'b01010;
	    numOfTea=5'b01010;
	end

	//Modify the lines below to implement your design
	always @(posedge CLK)
	begin
		invalidProduct=1'b0;
		productReady=1'b0;
		notExactFund=1'bx; 
		sugarUnsuitable=1'bx; 
		productUnavailable=1'b0;
		itemLeft=5'bxxxxx;
		insufficientFund=1'bx;  
		moneyLeft=5'b00000;

		if(vm == 0)
		begin
			if( productID==3'b000)
			begin
				if(numOfSandwiches<=5'b00000)
				begin
					productUnavailable=1'b1;
					moneyLeft=money;
				end
				
				else if(money!=6'b010100)
				begin
					notExactFund=1'b1;
					moneyLeft=money;
				end

				else 
				begin
					numOfSandwiches=numOfSandwiches-5'b00001;
					productReady=1'b1;
					moneyLeft= 5'b00000;
					itemLeft=numOfSandwiches;
					notExactFund=1'b0;	
				end

			end

			else if( productID==3'b001)
			begin

				if(numOfChocolate<=5'b00000)
				begin
					productUnavailable=1'b1;
					moneyLeft=money;
				end

			
				else if(money!=6'b001010)
				begin
					notExactFund=1'b1;
					moneyLeft=money;
				end
				else 
				begin
					numOfChocolate=numOfChocolate-1'b1;
					productReady=1'b1;
					moneyLeft= 5'b00000;	
					itemLeft=numOfChocolate;
					notExactFund=1'b0;	
				end
				
			end

			else if( productID==3'b010)
			begin	
				if(numOfWaterVM1<=5'b00000)
				begin
					productUnavailable=1'b1;
					moneyLeft=money;
				end
				
				else if(money!=6'b000101)
				begin
					invalidProduct=1'b0;
					notExactFund=1'b1;
					moneyLeft=money;
				end
				else 
				begin
					numOfWaterVM1=numOfWaterVM1-1'b1;
					productReady=1'b1;
					moneyLeft= 5'b00000;	
					itemLeft=numOfWaterVM1;
					notExactFund=1'b0;
				end
			end

			else 
			begin
				invalidProduct=1'b1;
				productUnavailable=1'bx;
				moneyLeft=money;
			end

		end

		if(vm == 1'b1)
		begin
			sugarUnsuitable=1'b0;
			if( productID==3'b010)
			begin

				if(numOfWaterVM2<=5'b00000)
				begin
					productUnavailable=1'b1;
					moneyLeft=money;
				end
				else if(sugar)
				begin
					sugarUnsuitable=1'b1;
					moneyLeft=money;
				end

				else if(money<6'b000101)
				begin
					insufficientFund=1'b1;
					moneyLeft=money;
				end
				
				else 
				begin
					numOfWaterVM2=numOfWaterVM2-1'b1;
					productReady=1'b1;
					moneyLeft= money-6'b000101;	
					itemLeft=numOfWaterVM2;	
					insufficientFund=1'b0;
				end

			end

			else if( productID==3'b011)
			begin

				if(numOfCoffee<=5'b00000)
				begin
					productUnavailable=1'b1;
					moneyLeft=money;
				end
			
				else if(money<6'b001100)
				begin
					insufficientFund=1'b1;
					moneyLeft=money;
				end
				
				else 
				begin
					numOfCoffee=numOfCoffee-1'b1;
					productReady=1'b1;
					moneyLeft= money-6'b001100;
					itemLeft=numOfCoffee;
					insufficientFund=1'b0;	
				end
				
			end

			else if( productID==3'b100)
			begin	
				if(numOfTea<=5'b00000)
				begin
					productUnavailable=1'b1;
					moneyLeft=money;
				end
			
				else if(money<6'b001000)
				begin
					insufficientFund=1'b1;
					moneyLeft=money;
				end
				
				else 
				begin
					numOfTea=numOfTea-1'b1;
					productReady=1'b1;
					moneyLeft= money-6'b001000;	
					itemLeft=numOfTea;
					insufficientFund=1'b0;
				end
			end
			
			else 
			begin
				invalidProduct=1'b1;
				sugarUnsuitable=1'bx; 
				productUnavailable=1'bx;
				moneyLeft=money;
			end
		end
	end
endmodule



