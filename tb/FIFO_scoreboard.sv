package FIFO_scoreboard_pkg;
import FIFO_transaction_pkg::*;
import shared_pkg::*;

    class FIFO_scoreboard;
        logic [FIFO_WIDTH-1:0] data_out_ref;
        logic wr_ack_ref, overflow_ref;
        logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

        logic [FIFO_WIDTH-1:0] FIFO_refmodel [$];

        function void check_data(FIFO_transaction F_txn);
            reference_model(F_txn);

            if (
                (F_txn.data_out != data_out_ref) ||
                (F_txn.wr_ack != wr_ack_ref) ||
                (F_txn.overflow != overflow_ref) ||
                (F_txn.underflow != underflow_ref) || 
                (F_txn.full != full_ref) ||
                (F_txn.almostfull!= almostfull_ref) ||
                (F_txn.empty != empty_ref) ||
                (F_txn.almostempty != almostempty_ref)
            ) begin
                error_cnt++;
                $display("************************************************************");
                $display("ERROR - DUT Out not equal Ref Model Out");
                $display("Input Signals:");
                $display("rst_n:%b", F_txn.rst_n);
                $display("wr_en:%b - rd_en:%b", F_txn.wr_en,F_txn.rd_en);
                $display("data_in:%d", F_txn.data_in);
                $display("----------------------");
                $display("DUT Outputs:");
                $display("data_out=%d", F_txn.data_out);
                $display("full=%b, almostfull= %b", F_txn.full, F_txn.almostfull);
                $display("empty=%b, almostempty= %b", F_txn.empty, F_txn.almostempty);
                $display("overflow=%b, underflow= %b", F_txn.overflow, F_txn.underflow);
                $display("wr_ack_ref=%b", F_txn.wr_ack);
                $display("----------------------");
                $display("Ref Model Outputs:");
                $display("data_out=%d", data_out_ref);
                $display("full=%b, almostfull= %b", full_ref, almostfull_ref);
                $display("empty=%b, almostempty= %b", empty_ref, almostempty_ref);
                $display("overflow=%b, underflow= %b", overflow_ref, underflow_ref);
                $display("wr_ack_ref=%b", wr_ack_ref);
                $display("************************************************************");
            end
            else begin
                correct_cnt++;
                $display("************************************************************");
                $display("PASS");
                $display("Input Signals:");
                $display("rst_n:%b", F_txn.rst_n);
                $display("wr_en:%b - rd_en:%b", F_txn.wr_en,F_txn.rd_en);
                $display("data_in:%d", F_txn.data_in);
                $display("----------------------");
                $display("DUT Outputs:");
                $display("data_out=%d", F_txn.data_out);
                $display("full=%b, almostfull= %b", F_txn.full, F_txn.almostfull);
                $display("empty=%b, almostempty= %b", F_txn.empty, F_txn.almostempty);
                $display("overflow=%b, underflow= %b", F_txn.overflow, F_txn.underflow);
                $display("wr_ack_ref=%b", F_txn.wr_ack);
                $display("----------------------");
                $display("Ref Model Outputs:");
                $display("data_out=%d", data_out_ref);
                $display("full=%b, almostfull= %b", full_ref, almostfull_ref);
                $display("empty=%b, almostempty= %b", empty_ref, almostempty_ref);
                $display("overflow=%b, underflow= %b", overflow_ref, underflow_ref);
                $display("wr_ack_ref=%b", wr_ack_ref);
                $display("************************************************************");
            end
        endfunction
//FIFO_1//FIFO_2//FIFO_3//FIFO_4//FIFO_5//FIFO_6//FIFO_7//FIFO_8//FIFO_9//FIFO_10//FIFO_11//FIFO_12
        function void reference_model (FIFO_transaction F_txn);
            if (!F_txn.rst_n) begin
                empty_ref = 1;
                full_ref = 0;
                underflow_ref = 0;
                overflow_ref = 0;
                almostempty_ref = 0;
                almostfull_ref = 0;
                wr_ack_ref = 0;
                FIFO_refmodel.delete();
            end 
            else begin

                wr_ack_ref = (F_txn.wr_en && FIFO_refmodel.size() < FIFO_DEPTH) ? 1 : 0;

                //Write
                if (F_txn.wr_en && !full_ref) begin
                    FIFO_refmodel.push_back(F_txn.data_in);
                end
                else begin
                    overflow_ref = (F_txn.wr_en && full_ref)? 1 : 0;
                end
                //Read
                if (F_txn.rd_en && !empty_ref) begin
                    data_out_ref = FIFO_refmodel.pop_front();
                end
                else begin
                    underflow_ref = (F_txn.rd_en && empty_ref) ? 1 : 0;
                end
                
                full_ref = (FIFO_refmodel.size() == FIFO_DEPTH) ? 1 : 0;
                empty_ref = (FIFO_refmodel.size() == 0) ? 1 : 0;
                almostfull_ref = (FIFO_refmodel.size() == FIFO_DEPTH-1) ? 1 : 0;
                almostempty_ref = (FIFO_refmodel.size() == 1) ? 1 : 0;
            end
            
        endfunction
    endclass
endpackage