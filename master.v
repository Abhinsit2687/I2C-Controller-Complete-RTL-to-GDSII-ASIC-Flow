module master(
    input clk,
    input rst,
    output reg scl,
    inout reg sda
);

reg [3:0] state;
reg [3:0] bit_index;
reg [7:0] data;
reg sda_out;

parameter IDLE  = 0,
          START = 1,
          SEND  = 2,
          STOP  = 3,
          DONE  = 4;

assign sda = (sda_out) ? 1'b0 : 1'bz;  // drive low for 0, high-Z for 1

always @(posedge clk or posedge rst) begin
    if (rst) begin
        scl <= 1;
        sda_out <= 0;
        state <= IDLE;
        bit_index <= 0;
        data <= 8'b10101010; // example byte
    end else begin
        case(state)
            IDLE: begin
                sda_out <= 1;
                scl <= 1;
                state <= START;
            end

            START: begin
                sda_out <= 0; // start condition: SDA goes low while SCL high
                state <= SEND;
                bit_index <= 7;
            end

            SEND: begin
                scl <= 0; // pull SCL low
                sda_out <= data[bit_index];
                #5 scl <= 1; // clock pulse
                #5 scl <= 0;
                if (bit_index == 0)
                    state <= STOP;
                else
                    bit_index <= bit_index - 1;
            end

            STOP: begin
                scl <= 1;
                sda_out <= 0;
                #5 sda_out <= 1; // stop condition: SDA goes high while SCL high
                state <= DONE;
            end

            DONE: begin
                scl <= 1;
                sda_out <= 1;
            end
        endcase
    end
end
endmodule

