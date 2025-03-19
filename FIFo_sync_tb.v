module FIFo_sync_tb;
  parameter width=8, depth=8;
  reg clk;
  reg reset;
  reg fifo_wrEn;
  reg fifo_rdEn;
  reg [width-1:0] fifo_wrData;
  wire [width-1:0] fifo_rdData;
  wire fifo_empty;
  wire fifo_full;
  wire [$clog2(depth):0] data_count;

  FIFO_syn  #(.width(width), .depth(depth)) dut (
    .clk(clk),
    .reset(reset),
    .fifo_wrEn(fifo_wrEn),
    .fifo_rdEn(fifo_rdEn),
    .fifo_wrData(fifo_wrData),
    .fifo_rdData(fifo_rdData),
    .fifo_empty(fifo_empty),
    .fifo_full(fifo_full),
    .data_count(data_count)
  );

  integer i;

  // Clock generation
  initial begin 
    clk = 0;
  end
  always #10 clk = ~clk;  // Clock period of 20 time units

  // Reset and FIFO Write/Read test sequence
  initial begin
    // Initializing signals
    reset = 0;
    fifo_wrEn = 0;
    fifo_rdEn = 0;
    fifo_wrData = 8'd0;

    // Assert reset for 2 clock cycles
    @(posedge clk);
    reset = 1;
    @(posedge clk);
    reset = 0;
    @(posedge clk);

    // Write data to FIFO, then read data
    for(i = 0; i < 5; i = i + 1) begin
      // Write data to FIFO
      @(posedge clk);
      fifo_wrEn = 1;
      fifo_wrData = fifo_wrData + 1;  // Increment data
      @(posedge clk);
      fifo_wrEn = 0;  // Disable write enable after one clock cycle

      // Read data from FIFO
      @(posedge clk);  // Wait for the next clock cycle
      fifo_rdEn = 1;   // Enable read
      @(posedge clk);
       @(posedge clk);          		// Wait for the falling edge
      fifo_rdEn = 0; 
		// Disable read enable
    end
	 for(i = 0; i < 10; i = i + 1) begin
	 @(posedge clk);
      fifo_wrEn = 1;
      fifo_wrData = fifo_wrData + 1;
	
	 @(posedge clk);
    @(posedge clk);	 // Wait for the next clock cycle
      fifo_rdEn = 1;
	 end
	 
  end

  // Allow the simulation to run for a certain amount of time before finishing
  initial begin
    for(i = 0; i < 25; i = i + 1) begin
      repeat(2) @(posedge clk);  // Wait for two clock cycles
    end
    $finish;  // End simulation
  end

  // Optional: Add some monitoring of FIFO states
  initial begin
    $monitor("Time: %0t | fifo_empty: %b | fifo_full: %b | data_count: %d", $time, fifo_empty, fifo_full, data_count);
  end
endmodule
