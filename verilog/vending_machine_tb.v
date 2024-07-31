`timescale 1ns/1ps

module VendingMachine_tb;
    reg clk;
    reg rst;
    reg [2:0] coin;
    reg [2:0] item;
    reg cancel;
    wire [2:0] dispense;
    wire [4:0] change;
    wire [1:0] state;
    wire [4:0] total;

    VendingMachine uut (
        .clk(clk),
        .rst(rst),
        .coin(coin),
        .item(item),
        .cancel(cancel),
        .dispense(dispense),
        .change(change),
        .state(state),
        .total(total)
    );

    // Coin values
    localparam [2:0] RS1 = 3'b001;
    localparam [2:0] RS2 = 3'b010;
    localparam [2:0] RS5 = 3'b011;
    localparam [2:0] RS10 = 3'b100;

    //Item Definition
    localparam [2:0] TOFFEE = 3'b001;
    localparam [2:0] CHOCOLATE = 3'b010;
    localparam [2:0] BISCUITS = 3'b011;
    localparam [2:0] CHIPS = 3'b100;
    localparam [2:0] JUICE = 3'b101;
    localparam [2:0] COLD_DRINK = 3'b110;

    // Clock generation
    always #5 clk = ~clk;  // 10ns clock period (100MHz)

    // Test sequence
    initial begin
        $dumpfile("ven_waveform.vcd");
        $dumpvars(1);
        // Initialize inputs
        clk = 1;
        rst = 1;
        coin = 0;
        item = 0;
        cancel = 0;

        // Reset the system
        #20 rst = 0;

        // Test case 1
        #10 item = TOFFEE;  // Select item 1 (Rs5)
        #10 coin = RS10;  // Rs1
        #10 coin = 0;  // Stop inserting coins
        #30
        // Test case 2
        #10 item = CHOCOLATE;  // Select item 1 (Rs5)
        #10 coin = RS2;  // Rs1
        #10 coin = RS2;  // Rs1
        #10 coin = RS2;  // Rs1
        #10 coin = 0;  // Stop inserting coins
        #30
        // Test case 3
        #10 item = CHIPS;  // Select item 1 (Rs5)
        #10 coin = RS5;  // Rs1
        #10 coin = RS5;  // Rs1
        #10 coin = 0;  // Stop inserting coins
        #30
        // Test case 4
        #10 item = JUICE;  // Select item 1 (Rs5)
        #10 coin = RS10;  // Rs1
        #10 coin = RS5;  // Rs1
        #10 coin = 0; cancel = 1;
        #10 cancel = 0;
        #50 $finish();  // End simulation
    end
endmodule


