import FIFO_coverage_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_transaction_pkg::*;
import shared_pkg::*;
module FIFO_monitor (FIFO_if fifo_if);

    FIFO_transaction F_txn;
    FIFO_scoreboard F_scrbrd;
    FIFO_coverage F_cvg;

    initial begin
        F_txn = new;
        F_scrbrd = new;
        F_cvg = new;
        forever begin
            wait (emonitor.triggered);
            @(negedge fifo_if.clk); 
            F_txn.rst_n = fifo_if.rst_n;
            F_txn.wr_en = fifo_if.wr_en;
            F_txn.rd_en = fifo_if.rd_en;
            F_txn.data_in = fifo_if.data_in;
            F_txn.data_out = fifo_if.data_out;
            F_txn.full = fifo_if.full;
            F_txn.almostfull = fifo_if.almostfull;
            F_txn.empty = fifo_if.empty;
            F_txn.almostempty = fifo_if.almostempty;
            F_txn.overflow = fifo_if.overflow;
            F_txn.underflow = fifo_if.underflow;
            F_txn.wr_ack = fifo_if.wr_ack;
            fork
                begin
                    F_cvg.sample_data(F_txn);
                end
                begin
                    F_scrbrd.check_data(F_txn);
                end
            join
            if (test_finished) begin
                $display("Correct Tests = %d, Error Tests = %d", correct_cnt, error_cnt);
                $stop;
            end
        end
    end
endmodule