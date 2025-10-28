package FIFO_coverage_pkg;
import FIFO_transaction_pkg::*;
class FIFO_coverage;
    FIFO_transaction F_cvg_txn;
    covergroup FIFO_cvr;

        //FIFO_2//FIFO_3//FIFO_4//FIFO_5//FIFO_6//FIFO_7//FIFO_8//FIFO_9//FIFO_10//FIFO_11//FIFO_12
        write_en: coverpoint F_cvg_txn.wr_en;
        read_en: coverpoint F_cvg_txn.rd_en;
        full: coverpoint F_cvg_txn.full;
        almostfull: coverpoint F_cvg_txn.almostfull;
        empty: coverpoint F_cvg_txn.empty;
        almostempty: coverpoint F_cvg_txn.almostempty;
        overflow: coverpoint F_cvg_txn.overflow;
        underflow: coverpoint F_cvg_txn.underflow;
        write_ack: coverpoint F_cvg_txn.wr_ack;

        cross_full: cross write_en, read_en, full{
            ignore_bins full1 = binsof (write_en) intersect {1} && binsof (read_en) intersect {1} && binsof (full) intersect {1};
            ignore_bins full2 = binsof (write_en) intersect {0} && binsof (read_en) intersect {1} && binsof (full) intersect {1};
        }
        cross_almostfull: cross write_en, read_en, almostfull;
        cross_empty:cross write_en, read_en, empty;
        cross_almostempty:cross write_en, read_en, almostempty;
        cross_overflow:cross write_en, read_en, overflow{
            ignore_bins overflow1 = binsof (write_en) intersect {0} && binsof (read_en) intersect {1} && binsof (overflow) intersect {1};
            ignore_bins overflow2 = binsof (write_en) intersect {0} && binsof (read_en) intersect {0} && binsof (overflow) intersect {1};
        }
        cross_underflow:cross write_en, read_en, underflow{
            ignore_bins underflow1 = binsof (write_en) intersect {1} && binsof (read_en) intersect {0} && binsof (underflow) intersect {1};
            ignore_bins underflow2 = binsof (write_en) intersect {0} && binsof (read_en) intersect {0} && binsof (underflow) intersect {1};
        }
        cross_write_ack:cross write_en, read_en, write_ack{
            ignore_bins wr_ack1 = binsof (write_en) intersect {0} && binsof (read_en) intersect {1} && binsof (write_ack) intersect {1};
            ignore_bins wr_ack2 = binsof (write_en) intersect {0} && binsof (read_en) intersect {0} && binsof (write_ack) intersect {1};
        }
        
    endgroup

    function new();
        FIFO_cvr = new;
    endfunction

    function void sample_data(FIFO_transaction F_txn);
        this.F_cvg_txn = F_txn;
        FIFO_cvr.sample();
    endfunction
endclass
endpackage

