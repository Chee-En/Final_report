module simple_filter #(
    parameter WIDTH = 16
)(
    input              clk,
    input              rstn,        // �D�P�B reset�]low active�^
    input  [11:0]       x_in,        // ���J����J��ơ]12-bit�^
    input              x_valid,     // ��Ʀ��ĺX��

    output reg [31:0]  bram_addr,   // BRAM ��} (word-addressed)
    output reg [31:0]  bram_data,   // BRAM ��ơ]32-bit �g�J�^
    output reg        bram_en,     // BRAM enable
    output reg [3:0]   bram_we      // BRAM write enable (�C�� byte �� 1 bit)
);

    // �x�s���v��J�˥�
    reg signed [WIDTH-1:0] x_n, x_n1, x_n2;

    // FIR �o�i�Y�Ƭ��Gx[n]*0.25 + x[n-1]*0.5 + x[n-2]*0.25
    // �����줸�B�⬰�Gx[n]<<6 + x[n-1]<<7 + x[n-2]<<6�A�A >> 8
    wire signed [WIDTH+7:0] mult0 = (x_n  <<< 6);   // x[n] * 64
    wire signed [WIDTH+7:0] mult1 = (x_n1 <<< 7);   // x[n-1] * 128
    wire signed [WIDTH+7:0] mult2 = (x_n2 <<< 6);   // x[n-2] * 64

    wire signed [WIDTH+9:0] sum_all = mult0 + mult1 + mult2;
    wire signed [WIDTH+1:0] y_temp  = sum_all >>> 8;

    wire signed [15:0] y_saturated =
        (y_temp > 32767)  ? 16'sd32767 :
        (y_temp < -32768) ? -16'sd32768 :
        y_temp[15:0];

    // �H�s���޿�
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            x_n     <= 0;
            x_n1    <= 0;
            x_n2    <= 0;
            bram_addr <= 0;
            bram_data <= 0;
            bram_en   <= 0;
            bram_we   <= 4'b0000;
        end else begin
            bram_en <= 0;
            bram_we <= 4'b0000;

            if (x_valid) begin
                // ��s���v�˥�
                x_n2 <= x_n1;
                x_n1 <= x_n;
                x_n  <= {4'b0000, x_in};  // 12-bit �Ÿ��X�i�� 16-bit

                // �g�J BRAM
                bram_data <= {16'b0, y_saturated};
                bram_en   <= 1;
                bram_we   <= 4'b1111;
                bram_addr <= bram_addr + 1;
            end
        end
    end
endmodule
