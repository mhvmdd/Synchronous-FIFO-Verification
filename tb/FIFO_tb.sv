import shared_pkg::*;
import FIFO_transaction_pkg::*;
module FIFO_tb (FIFO_if f_if);

    
    logic [FIFO_WIDTH-1:0] FIFO_refmodel [$];
    logic [FIFO_WIDTH-1:0] data_out_ref;
    logic wr_ack_ref, overflow_ref;
    logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
    FIFO_transaction F_txn;

    int error_cnt_tb = 0, correct_cnt_tb = 0;

    initial begin
        F_txn = new;
        correct_cnt = 0;
        error_cnt = 0;
        test_finished = 0;
        //FIFO_1
        f_if.rst_n = 0;
        f_if.wr_en = 0;
        f_if.rd_en = 0;
        f_if.data_in = 0;
        ->emonitor;
        repeat(4)@(negedge f_if.clk);
        check_data();
        //FIFO_2//FIFO_3//FIFO_4//FIFO_5//FIFO_6//FIFO_7//FIFO_8//FIFO_9//FIFO_10//FIFO_11//FIFO_12
        repeat(3000) begin
            assert(F_txn.randomize());
            f_if.rst_n = F_txn.rst_n;
            f_if.wr_en = F_txn.wr_en;
            f_if.rd_en = F_txn.rd_en;
            f_if.data_in = F_txn.data_in;
            ->emonitor;
            @(negedge f_if.clk);
            check_data();
        end
        test_finished = 1;
        ->emonitor; 
        $display("Correct Test @TB = %d, Error Test @TB = %d", correct_cnt_tb, error_cnt_tb);
    end

    task check_data;
        ref_model();
        if (data_out_ref != f_if.data_out) begin
            error_cnt_tb++;
            $display("Error - DUT out: %h != Ref Model out: %h", f_if.data_out, data_out_ref);
        end
        else begin
            correct_cnt_tb ++;
        end
    endtask

    task ref_model;
            if (!f_if.rst_n) begin
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

                wr_ack_ref = (f_if.wr_en && FIFO_refmodel.size() < FIFO_DEPTH) ? 1 : 0;

                //Write
                if (f_if.wr_en && !full_ref) begin
                    FIFO_refmodel.push_back(f_if.data_in);
                end
                else begin
                    overflow_ref = (f_if.wr_en && full_ref)? 1 : 0;
                end
                //Read
                if (f_if.rd_en && !empty_ref) begin
                    data_out_ref = FIFO_refmodel.pop_front();
                end
                else begin
                    underflow_ref = (f_if.rd_en && empty_ref) ? 1 : 0;
                end
                
                full_ref = (FIFO_refmodel.size() == FIFO_DEPTH) ? 1 : 0;
                empty_ref = (FIFO_refmodel.size() == 0) ? 1 : 0;
                almostfull_ref = (FIFO_refmodel.size() == FIFO_DEPTH-1) ? 1 : 0;
                almostempty_ref = (FIFO_refmodel.size() == 1) ? 1 : 0;
            end
    endtask


endmodule
