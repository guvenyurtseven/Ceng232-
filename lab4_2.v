`timescale 1ns / 1ps
module SelectionOfAvatar(
	input [1:0] mode,
	input [5:0] userID,
	input [1:0] candidate, // 00:Air 01:Fire, 10:Earth, 11: Water
	input CLK,
	output reg [1:0] ballotBoxId,
	output reg [5:0] numberOfRegisteredVoters,
	output reg [5:0] numberOfVotesWinner, // number of votes of winner
	output reg [1:0] WinnerId,
	output reg AlreadyRegistered,
	output reg AlreadyVoted,
	output reg NotRegistered,
	output reg VotingHasNotStarted,
	output reg RegistrationHasEnded
	);

    reg [5:0] registered [0:63];
    reg [5:0] voted [0:63];
    integer i, clock, registeredNum, votedNum;
    integer airV, fireV, waterV, earthV;
	
	initial begin
        clock = 0;
		registeredNum = 0;
		votedNum = 0;
		airV = 0;
		fireV = 0;
		waterV = 0;
		earthV = 0;
		for(i=0; i<64; i = i+1) begin
            registered[i]=6'b000000;
            voted[i]=6'b000000;
        end
	end

	always @(posedge CLK)
	begin
		clock=clock+1;
        ballotBoxId =0;
        numberOfRegisteredVoters=0;
        numberOfVotesWinner=0;
        WinnerId=0;
        AlreadyRegistered=0;
        AlreadyVoted=0;
        NotRegistered=0;
        VotingHasNotStarted=0;
        RegistrationHasEnded=0;

        if(clock<=100) begin
            ballotBoxId=userID[5:4];
            if(mode==1) begin
                VotingHasNotStarted=1;
            end
            if(mode==0) begin
                if(registered[userID]==0) begin
                    registered[userID]=1;
                    ballotBoxId=userID[5:4];
                    registeredNum=registeredNum+1;
                end

                else begin 
                    AlreadyRegistered=1;
                    ballotBoxId=userID[5:4];
                end
            end
            numberOfRegisteredVoters=registeredNum;
        end
        else if(clock<=200) begin
            ballotBoxId=userID[5:4];
            numberOfRegisteredVoters=registeredNum;
            if(mode==0) begin
                RegistrationHasEnded=1;
            end
            if(mode==1) begin
                if(registered[userID]==1) begin
                    if(voted[userID]==0)begin
                        voted[userID]=1;
                        if(candidate==0)begin
                            airV=airV+1;
                        end
                        if(candidate==1)begin
                            fireV=fireV+1;
                        end
                        if(candidate==2)begin
                            waterV=waterV+1;
                        end
                        if(candidate==3)begin
                            earthV=earthV+1;
                        end
                    end 
                    else begin
                        AlreadyVoted=1;
                    end   
                end
                else begin
                    NotRegistered=1;
                end
            end    
            
        end
        else if(clock>200) begin
            numberOfRegisteredVoters=registeredNum;
            numberOfVotesWinner=airV;
            WinnerId=2'b0;
            if (fireV > numberOfVotesWinner) begin
				numberOfVotesWinner = fireV;
				WinnerId = 2'b01;
			end
			if (waterV > numberOfVotesWinner) begin
				numberOfVotesWinner = waterV;
				WinnerId = 2'b10;
			end

			if (earthV> numberOfVotesWinner) begin
				numberOfVotesWinner = earthV;
				WinnerId = 2'b11;
			end
        end
	end

endmodule
