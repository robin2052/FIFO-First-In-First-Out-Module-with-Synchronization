module Ram #(parameter width=8,depth=16)(
           input clk,
           input wrEn,          //when it will be high we will be able to write data
			  input [width-1:0] wrData,   //the data to be written
			  input rdEn,           //should be high to read the data
			  input [$clog2(depth)-1:0] wrAdress, //addresss where to be write the data
			  input [$clog2(depth)-1:0] rdAdress, //address from where data will be read
			  output reg [width-1:0] rdData);  //data that is being read it is the output data
			  
			  
			  reg [width-1:0] mem [depth-1:0];
			  //writing memory Logic
			  
always @(posedge clk) begin
if (wrEn) begin
   mem[wrAdress]<= wrData;

end 

if(rdEn) begin
rdData<=mem[rdAdress];
end 

end
			  
			  
endmodule