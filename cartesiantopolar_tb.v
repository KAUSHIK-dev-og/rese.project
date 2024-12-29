module cartesiantopolar_tb;

    // Inputs
    reg signed [7:0] x;
    reg signed [7:0] y;

    // Outputs
    wire [7:0] r1;
    wire signed [7:0] theta1;

    // Instantiate the Unit Under Test (UUT)
    cartesiantopolar uut (
        .x(x),
        .y(y),
        .r1(r1),
        .theta1(theta1)
    );

    initial begin
        // Initialize inputs and apply test cases
        $display("Testing Cartesian to Polar Coordinate Conversion with 8-bit inputs");

        // Test case 1: x=0, y=0
        x = 8'sd0; y = 8'sd0;
        #10;
        $display("x=%d, y=%d -> r1=%d, theta1=%d", x, y, r1, theta1);

        // Test case 2: x=3, y=4
        x = 8'sd3; y = 8'sd4;
        #10;
        $display("x=%d, y=%d -> r1=%d, theta1=%d", x, y, r1, theta1);

        // Test case 3: x=6, y=8
        x = 8'sd6; y = 8'sd8;
        #10;
        $display("x=%d, y=%d -> r1=%d, theta1=%d", x, y, r1, theta1);

        // Test case 4: x=1, y=1
        x = 8'sd1; y = 8'sd1;
        #10;
        $display("x=%d, y=%d -> r1=%d, theta1=%d", x, y, r1, theta1);

        // Test case 5: x=-3, y=4
        x = -8'sd3; y = 8'sd4;
        #10;
        $display("x=%d, y=%d -> r1=%d, theta1=%d", x, y, r1, theta1);

        // Test case 6: x=1, y=-1
        x = 8'sd1; y = -8'sd1;
        #10;
        $display("x=%d, y=%d -> r1=%d, theta1=%d", x, y, r1, theta1);

        // Test case 7: x=-12, y=-5
        x = -8'sd12; y = -8'sd5;
        #10;
        $display("x=%d, y=%d -> r1=%d, theta1=%d", x, y, r1, theta1);

        // Test case 8: Random values
        x = 8'sd123; y = -8'sd45;
        #10;
        $display("x=%d, y=%d -> r1=%d, theta1=%d", x, y, r1, theta1);

        $finish; // End the simulation
    end

endmodule
