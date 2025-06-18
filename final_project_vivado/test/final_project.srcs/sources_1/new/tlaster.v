`timescale 1ns / 1ps

module tlaster #(
    parameter DATA_WIDTH = 32,
    parameter TID_WIDTH  = 1,
    parameter TDEST_WIDTH = 1,
    parameter TUSER_WIDTH = 1
)(
    input wire clk,
    input wire rstn,

    // AXI Stream input
    input wire [DATA_WIDTH-1:0] s_axis_tdata,
    input wire                  s_axis_tvalid,
    output wire                 s_axis_tready,

    // AXI Stream output
    output wire [DATA_WIDTH-1:0] m_axis_tdata,
    output wire                  m_axis_tvalid,
    input  wire                  m_axis_tready,
    output wire                  m_axis_tlast,
    
    output wire [TID_WIDTH-1:0]    m_axis_tid,
    output wire [TDEST_WIDTH-1:0]  m_axis_tdest,
    output wire [TUSER_WIDTH-1:0]  m_axis_tuser
);

    assign m_axis_tdata  = s_axis_tdata;
    assign m_axis_tvalid = s_axis_tvalid;
    assign s_axis_tready = m_axis_tready;

    // 固定產出 tlast=1'b1（表示每筆都是 frame 結尾）
    assign m_axis_tlast  = 1'b1;

    // 以下保留不使用
    assign m_axis_tid    = {TID_WIDTH{1'b0}};
    assign m_axis_tdest  = {TDEST_WIDTH{1'b0}};
    assign m_axis_tuser  = {TUSER_WIDTH{1'b0}};

endmodule
