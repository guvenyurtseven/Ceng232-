module bh(input B, input H, input clk, output reg Q);

always @(posedge clk) begin
    case({B,H})
        2'b00: Q <= ~Q;
        2'b01: Q <= 1;
        2'b10: Q <= 0;
        2'b11: Q <= Q;
    endcase
end
endmodule




module ic1337(input A0, input A1, input A2, input clk, output Q0, output Q1, output Z);

reg bh_q0, bh_q1;

bh bh0(.B((~A1^A0) | A2), .H(~A2 & A0), .clk(clk), .Q(bh_q0));
bh bh1(.B((~A2) & A0), .H(((~A0) ~| A1) & A2), .clk(clk), .Q(bh_q1));

assign Q0 = bh_q0;
assign Q1 = bh_q1;
assign Z = (Q0 ~^ Q1);

end
endmodule