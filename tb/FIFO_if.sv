interface FIFO_if (clk);
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    input clk;
    logic [FIFO_WIDTH-1:0] data_in;
    logic rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;

    // Monitor modport
    modport monitor (
        input clk, rst_n, wr_en, rd_en,
        input data_in, data_out,
        input wr_ack, overflow,
        input full, empty, almostfull, almostempty, underflow
    );

    // Test modport
    modport test (
        input clk,
        output rst_n, wr_en, rd_en, data_in,
        input data_out, wr_ack, overflow,
        input full, empty, almostfull, almostempty, underflow
    );

    // DUT modport
    modport dut (
        input clk, rst_n, wr_en, rd_en, data_in,
        output data_out, wr_ack, overflow,
        output full, empty, almostfull, almostempty, underflow
    );
endinterface
