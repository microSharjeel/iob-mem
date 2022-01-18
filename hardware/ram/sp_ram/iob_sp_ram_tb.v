`timescale 1ns / 1ps

module iob_sp_ram_tb;
   
   // Inputs
   reg clk;
   reg en; // enable access to ram
   reg we; // write enable
   reg [`ADDR_W-1:0] addr;
   reg [`DATA_W-1:0] data_in;
   
   // Ouptuts
   reg [`DATA_W-1:0] data_out;

   integer           i, seq_ini;

   parameter clk_per = 10; // clk period = 10 timeticks

   initial begin
      // optional VCD
`ifdef VCD
      $dumpfile("uut.vcd");
      $dumpvars();
`endif
      
      // Initialize Inputs
      clk = 1;
      en = 0;
      we = 0;
      addr = 0;

      // Number from which to start the incremental sequence to write into the RAM
      seq_ini = 32;

      #clk_per;
      @(posedge clk) #1;
      en = 1;

      // Write to all RAM words
      @(posedge clk) #1;
      we = 1;

      for(i = 0; i < 2**`ADDR_W; i = i + 1) begin
         addr = i;
         data_in = i+seq_ini;
         @(posedge clk) #1;
      end

      @(posedge clk) #1;
      we = 0;

      // Read from all RAM words
      @(posedge clk) #1;
      for(i = 0; i < 2**`ADDR_W; i = i + 1) begin
         addr = i;
         @(posedge clk) #1;
         if(i+seq_ini != data_out) begin
            $display("Test failed: read error in data_out. \n \t i=%0d; data = %h when it should have been %0h", i, i+seq_ini, data_out);
            $finish;
         end
      end

      @(posedge clk) #1;
      en = 0;

      #clk_per;
      $display("%c[1;34m",27);
      $display("Test completed successfully.");
      $display("%c[0m",27);
      #(5*clk_per) $finish;

   end

   // Instantiate the Unit Under Test (UUT)
   iob_sp_ram 
     #(
       .DATA_W(`DATA_W), 
       .ADDR_W(`ADDR_W)
       ) 
   uut 
     (
      .clk(clk), 
      .en(en),
      .we(we),
      .addr(addr),
      .din(data_in),
      .dout(data_out)
      );
   
   // system clock
   always #(clk_per/2) clk = ~clk; 

endmodule
