module slave(
    input clk,
    input rst,
    input scl,
    inout wire sda
);
reg [7:0] data_received;
reg [3:0] bit_index;
reg sda_prev;

assign sda = 1'bz; // slave just reads

always @(posedge clk or posedge rst) begin
    if (rst) begin
        bit_index <= 7;
        data_received <= 0;
        sda_prev <= 1;
    end else begin
        sda_prev <= sda;
        // detect rising edge of SCL and read SDA
        if (scl && sda_prev != sda) begin
            data_received[bit_index] <= sda;
            if (bit_index == 0)
                bit_index <= 7;
            else
                bit_index <= bit_index - 1;
        end
    end
end
endmodule

