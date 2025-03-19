module FIFO_syn #(parameter width=8,depth=8)(
input clk,
input reset,
input fifo_wrEn,
input fifo_rdEn,
input [width-1:0] fifo_wrData,
input [width-1:0] fifo_rdData,
output fifo_empty,
output fifo_full,
output [$clog2(depth):0] data_count);//here i express the bit as 4 bit though the count can be expressed by 3 bit.
                                    //the reason behind it is to show the count value as exact the bit. that means when
                                    //count is 8 it will show 1000. so i need 4 bit
		//writing the wren logic
      reg wrEnint; //here the external fifo_wrEn will come from processor or other module that wants to write the data.	
		reg [width-1:0] fifo_wrDatap;
		reg [$clog2(depth):0] bit_counter;
		
		reg [$clog2(depth)-1:0]wradress;
		reg [$clog2(depth)-1:0]rdadress;
		
		assign data_count=bit_counter;
	   assign fifo_full= (data_count==depth);
	   assign fifo_empty=(data_count==0);
		assign validfifo_wren=!fifo_full && fifo_wrEn;
	   assign validfifo_rden= !fifo_empty && fifo_rdEn;
		
		
		always @(posedge clk) begin //here is a problem with wrEnint .that is when clk will be high the wrEnint will be high after one clkcycle. but the write data will come immediately from tha ram
		if (reset) begin
		wrEnint<=0;
		end
		else if (!fifo_full && fifo_wrEn ) begin
		wrEnint<=1'b1;
		end
		else wrEnint<=0;
       end		
	
  	
   always @(posedge clk) begin   //synchronized with wrenintand the problem is now reduced
	fifo_wrDatap<=fifo_wrData;
	end

	
	
	//now we will derive the fifo_full logic
	//we should make a counter than. if value is equal to depth than id is full.
	
	
	
	
	always @(posedge clk) begin
	if (reset) bit_counter<=0;
	else if ( validfifo_wren && !validfifo_rden) bit_counter<=bit_counter+1;
	else if (validfifo_rden && !validfifo_wren)  bit_counter<=bit_counter-1;
	end
	
	always @(posedge clk ) begin
	if (reset) wradress<=0;
	else if (wrEnint) wradress<=wradress+1;
	end 
	
	always @(posedge clk ) begin
	if (reset) rdadress<=0;
	else if (validfifo_rden) rdadress<=rdadress+1;
	end
	
	
	 
	
	
	
	
	
 Ram #( .width(width),.depth(depth)) dut1 (
          .clk(clk),
          .wrEn(wrEnint),          //when it will be high we will be able to write data.In this it can have to be manipulated as there is a matter of fifo full and empty
			 .wrData(fifo_wrDatap),   //the data to be written
			 .rdEn(validfifo_rden),           //should be high to read the data.In this it can have to be manipulated as there is a matter of fifo full and empty
			 .wrAdress(wradress), //addresss where to be write the data. We should add a generation logic of writedata
			 .rdAdress(rdadress), //address from where data will be read. We should add a generation logic of readdata
			 .rdData(fifo_rdData));  //data that is being read it is the output data

endmodule


