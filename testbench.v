module testbench;
    reg clk, rst;
    reg scl;
    reg sda;

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;  // 10 ns period

    // Reset
    initial begin
        rst = 1;
        #10 rst = 0;
    end

    // Simulation of I2C write byte
    initial begin
        // Initialize
        scl = 1;
        sda = 1;
        #10;

        // Start condition
        sda = 0; scl = 1;
        #10;

        // Send 8-bit data: 10101010
        // Each bit: SDA changes when SCL=0, sampled on SCL=1
        sda = 1; scl = 0; #10; scl = 1; #10;
        sda = 0; scl = 0; #10; scl = 1; #10;
        sda = 1; scl = 0; #10; scl = 1; #10;
        sda = 0; scl = 0; #10; scl = 1; #10;
        sda = 1; scl = 0; #10; scl = 1; #10;
        sda = 0; scl = 0; #10; scl = 1; #10;
        sda = 1; scl = 0; #10; scl = 1; #10;
        sda = 0; scl = 0; #10; scl = 1; #10;

        // Stop condition
        sda = 0; scl = 1; #10;
        sda = 1; #10;

        #50 $finish;
    end
endmodule

