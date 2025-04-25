`timescale 1ns / 1ps

module map2(
input  clk, en,
input [RAM_ADDR_BITS-1:0] addr,
output reg [RAM_WIDTH-1:0]dataout
);


   parameter RAM_WIDTH = 1;
   parameter RAM_ADDR_BITS = 9;
   
   (* RAM_STYLE="{AUTO | BLOCK |  BLOCK_POWER1 | BLOCK_POWER2}" *)
   reg [RAM_WIDTH-1:0] map2 [299:0];


   //  The forllowing code is only necessary if you wish to initialize the RAM 
   //  contents via an external file (use $readmemb for binary data)
   initial
   $readmemb("map3.mem", map2, 0, 299);

   always @(posedge clk)
      if (en) begin
			dataout <= map2[addr];
      end
						
				
				
endmodule
