`timescale 1ns/1ps

module VendingMachine(
    input clk,
    input rst,
    input [2:0] coin,      // 3-bit output to represent coin denominations (001, 010, 011, 100)
    input [2:0] item,      // 3-bit output to represent item (001, 010, 011, 100, 101, 110)
    input cancel,          // 1-bit input to represent cancel transaction
    output reg [2:0] dispense,  // 3-bit output to represent dispensing item (001, 010, 011, 100, 101, 110)
    output reg [4:0] change,    // 5-bit output to represent returning change (0 to 31 Rs)
    output reg [1:0] state,     // 2-bit output to represent the current state
    output reg [4:0] total      // 5-bit output to represent the total amount inserted (0 to 31 Rs)
);

// State definitions
localparam ACCEPT  = 2'b00;
localparam DISPENSE= 2'b01;
localparam CANCEL  = 2'b10;

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


// Item prices
localparam TOFFEE_PRICE = 2;         // Rs2
localparam CHOCOLATE_PRICE = 5;     // Rs5
localparam BISCUITS_PRICE = 10;     // Rs10
localparam CHIPS_PRICE = 10;
localparam JUICE_PRICE = 20;
localparam COLD_DRINK_PRICE = 20;


always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= ACCEPT;
        total <= 0;
        dispense <= 3'b000;
        change <= 0;
    end else begin
        case (state)
            ACCEPT: begin
                change <= 0;
                if (cancel) begin
                    state <= CANCEL;
                    $display("Item was cancelled");
                end 
                else if (coin) begin
                    if (coin == RS1)
                        total <= total + 1;
                    else if (coin == RS2)
                        total <= total + 2;
                    else if (coin == RS5)
                        total <= total + 5;
                    else if (coin == RS10)
                        total <= total + 10;
                end
                if (item == TOFFEE && total >= TOFFEE_PRICE) begin
                        state <= DISPENSE;
                        dispense <= TOFFEE;
                        $display("TOFFEE successfully dispensed");
                    end else if (item == CHOCOLATE && total >= CHOCOLATE_PRICE) begin
                        state <= DISPENSE;
                        dispense <= CHOCOLATE;
                        $display("CHOCOLATE successfully");
                    end else if (item == BISCUITS && total >= BISCUITS_PRICE) begin
                        state <= DISPENSE;
                        dispense <= BISCUITS;
                        $display("BISCUITS successfully dispensed");
                        state <= ACCEPT;
                    end else if (item == CHIPS && total >= CHIPS_PRICE) begin
                        state <= DISPENSE;
                        dispense <= CHIPS;
                        $display("CHIPS successfully dispensed");
                    end else if (item == JUICE && total >= JUICE_PRICE) begin
                        state <= DISPENSE;
                        dispense <= JUICE;
                        $display("JUICE successfully dispensed");
                    end else if (item == COLD_DRINK && total >= COLD_DRINK_PRICE) begin
                        state <= DISPENSE;
                        dispense <= COLD_DRINK;
                        $display("COLD_DRINK successfully dispensed");
                    end
            end
            
            DISPENSE: begin
                if (dispense == TOFFEE) begin
                    change <= total - TOFFEE_PRICE;
                    dispense <= 3'b000;
                end else if (dispense == CHOCOLATE) begin
                    change <= total - CHOCOLATE_PRICE;
                    dispense <= 3'b000;
                end else if (dispense == BISCUITS) begin
                    change <= total - BISCUITS_PRICE;
                    dispense <= 3'b000;
                end else if (dispense == CHIPS) begin
                    change <= total - CHIPS_PRICE;
                    dispense <= 3'b000;
                end else if (dispense == JUICE) begin
                    change <= total - JUICE_PRICE;
                    dispense <= 3'b000;
                end else if (dispense == COLD_DRINK) begin
                    change <= total - COLD_DRINK_PRICE;
                    dispense <= 3'b000;
                end
                state <= ACCEPT;
                total <= 0;
                end
            CANCEL: begin
                change <= total;
                state <= ACCEPT;
                total <= 0;
                dispense <= 0;
            end
            default: begin
                state <= ACCEPT;
                total <= 0;
                dispense <= 0;
                change <= 0;
            end
        endcase
    end
end
endmodule

