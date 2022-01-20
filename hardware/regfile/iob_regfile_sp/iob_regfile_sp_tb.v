`timescale 1ns / 1ps

`define DATA_W 32
`define ADDR_W 4

module iob_regfile_sp_tb;

   // Inputs
   reg clk;
   reg rst;
   reg [`DATA_W-1:0] w_data;
   reg [`ADDR_W-1:0] addr;
   reg               en;

   // Ouptuts
   reg [`DATA_W-1 :0] r_data;

   integer            i, seq_ini;

   parameter clk_per = 10; // clk period = 10 timeticks

   initial begin
      // optional VCD
`ifdef VCD
      $dumpfile("uut.vcd");
      $dumpvars();
`endif

      // Initialize Inputs
      clk = 1;
      rst = 0;
      w_data = 0;
      addr = 0;
      en = 0;

      // Number from which to start the incremental sequence to write into the RAM
      seq_ini = 32;

      #clk_per;
      @(posedge clk) #1; 
      rst = 1;
      @(posedge clk) #1;
      rst = 0;

      @(posedge clk) #1;
      en = 1;

      // Write and real all the locations
      for(i=0; i < 2**`ADDR_W; i = i + 1) begin
         addr = i;
         w_data = i+seq_ini;
         @(posedge clk) #1;
         if(r_data != i+seq_ini) begin
            $display("Test 1 failed: read error in r_data.\n \t data=%0d; r_data=%0d", i+seq_ini, r_data);
            $finish;
         end
         @(posedge clk) #1;
      end

      @(posedge clk) #1;
      en = 0;
      addr = 0;

      // Read all the locations and check if still stored
      for(i=0; i < 2**`ADDR_W; i = i + 1) begin
         addr = i;
         @(posedge clk) #1;
         if(r_data != i+seq_ini) begin
            $display("Test 2 failed: read error in r_data.\n \t data=%0d; r_data=%0d", i+seq_ini, r_data);
            $finish;
         end
         @(posedge clk) #1;
      end

      // Resets the entire memory
      @(posedge clk) #1; 
      rst = 1;
      @(posedge clk) #1;
      rst = 0;

      // Read all the locations and check if reset worked
      for(i=0; i < 2**`ADDR_W; i = i + 1) begin
         addr = i;
         @(posedge clk) #1;
         if(r_data != 0) begin
            $display("Test 3 failed: r_data is not null");
            $finish;
         end
         @(posedge clk) #1;
      end

      #clk_per;
      $display("%c[1;34m",27);
      $display("Test completed successfully.");
      $display("%c[0m",27);
      #(5*clk_per) $finish;
   end

   // Instantiate the Unit Under Test (UUT)
   iob_regfile_sp
     #(
       .ADDR_W(`ADDR_W),
       .DATA_W(`DATA_W)
       )
   uut
     (
      .clk(clk), 
      .rst(rst),
      .we(en),
      .addr(addr),
      .w_data(w_data),
      .r_data(r_data)
      );

   // system clock
   always #(clk_per/2) clk = ~clk;

endmodule
