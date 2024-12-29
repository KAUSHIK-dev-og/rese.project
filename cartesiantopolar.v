module atan_calculator (
    input wire signed [7:0] x,   // X-coordinate (signed input)
    input wire signed [7:0] y,   // Y-coordinate (signed input)
    output reg signed [7:0] theta // Arctangent result (signed output in radians)
);
    reg signed [7:0] x_reg, y_reg;  // Registers for X and Y
    reg signed [7:0] z;             // Accumulated angle
    reg signed [7:0] atan_table [0:7]; // Lookup table for atan(2^-i)

    integer i;

    initial begin
        // Initialize atan lookup table (values in radians, scaled for fixed-point)
        atan_table[0]  = 8'd64; // atan(2^0)  = 45 degrees = ?/4 radians
        atan_table[1]  = 8'd38; // atan(2^-1) = 26.57 degrees
        atan_table[2]  = 8'd20; // atan(2^-2) = 14.03 degrees
        atan_table[3]  = 8'd10; // atan(2^-3) = 7.12 degrees
        atan_table[4]  = 8'd5;  // atan(2^-4)
        atan_table[5]  = 8'd3;  // atan(2^-5)
        atan_table[6]  = 8'd1;  // atan(2^-6)
        atan_table[7]  = 8'd0;  // atan(2^-7)
    end

    always @(*) begin
        // Initialize registers
        x_reg = x;
        y_reg = y;
        z = 0;

        // CORDIC iterative algorithm
        for (i = 0; i < 8; i = i + 1) begin
            if (y_reg > 0) begin
                x_reg = x_reg + (y_reg >>> i); // Rotate clockwise
                y_reg = y_reg - (x_reg >>> i);
                z = z + atan_table[i];
            end else begin
                x_reg = x_reg - (y_reg >>> i); // Rotate counter-clockwise
                y_reg = y_reg + (x_reg >>> i);
                z = z - atan_table[i];
            end
        end

        theta = z; // Output the accumulated angle
    end
endmodule

module sqrt_calculator (
    input wire [7:0] input_val,   // Input value
    output reg [7:0] output_val   // Square root result (8-bit)
);
    reg [15:0] remainder;         // Holds the remainder
    reg [7:0] root;               // Holds the square root being calculated
    reg [7:0] trial;              // Trial bit for testing

    integer i;

    always @(*) begin
        // Initialize
        remainder = input_val;
        root = 0;

        // Compute square root bit by bit
        for (i = 7; i >= 0; i = i - 1) begin
            trial = root | (1 << i);
            if (trial * trial <= remainder) begin
                root = trial;
            end
        end

        output_val = root; // Assign final square root
    end
endmodule

module cartesiantopolar (
    input wire signed [7:0] x,      // Real part (8-bit signed input)
    input wire signed [7:0] y,      // Imaginary part (8-bit signed input)
    output wire [7:0] r1,           // Magnitude (8-bit unsigned output)
    output wire signed [7:0] theta1 // Angle (8-bit signed output, in radians)
);

    // Internal wires for calculations
    wire [15:0] x_squared, y_squared, sum_squares;
    wire [7:0] magnitude; // Magnitude output from sqrt_calculator
    wire signed [7:0] atan_result; // Angle output from atan_calculator

    // Squaring x and y
    assign x_squared = x * x;
    assign y_squared = y * y;

    // Summing squares to calculate r1
    assign sum_squares = x_squared + y_squared;

    // Compute magnitude using a square root module
    sqrt_calculator sqrt_inst (
        .input_val(sum_squares[7:0]), // Truncate to 8 bits
        .output_val(magnitude)
    );

    assign r1 = magnitude; // Assigning magnitude to r1

    // Compute angle using an arctan module
    atan_calculator atan_inst (
        .x(x),
        .y(y),
        .theta(atan_result)
    );

    assign theta1 = atan_result; // Assigning angle to theta1

endmodule

