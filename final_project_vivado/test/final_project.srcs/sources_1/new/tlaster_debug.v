`timescale 1ns / 1ps

module tlaster_debug #(
    parameter DATA_WIDTH = 32,
    parameter COUNT_MAX = 256
)(
    input wire clk,
    input wire rstn,

    output reg [DATA_WIDTH-1:0] m_axis_tdata = 0,
    output reg                  m_axis_tvalid = 0,
    input  wire                 m_axis_tready,
    output reg                  m_axis_tlast = 0,
    output reg                  debug_led = 0
);

    reg [31:0] counter = 0;
    reg sending = 1;

    always @(posedge clk) begin
        if (!rstn) begin
            counter <= 0;
            m_axis_tvalid <= 0;
            m_axis_tlast <= 0;
            sending <= 1;
            debug_led <= 0;
        end else if (sending && m_axis_tready) begin
            m_axis_tdata <= counter;
            m_axis_tvalid <= 1;
            m_axis_tlast <= (counter == COUNT_MAX - 1);
            counter <= counter + 1;

            if (counter == COUNT_MAX - 1)
                debug_led <= 1;

            if (counter == COUNT_MAX) begin
                m_axis_tvalid <= 0;
                sending <= 0;
            end
        end
    end
endmodule
