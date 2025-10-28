package FIFO_transaction_pkg;
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    class FIFO_transaction;
        rand logic [FIFO_WIDTH-1:0] data_in;
        rand logic rst_n, wr_en, rd_en;
        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;
        int RD_EN_ON_DIST, WR_EN_ON_DIST;

        function new (int RD_EN_ON_DIST = 30 , int WR_EN_ON_DIST = 70);
            this.RD_EN_ON_DIST = RD_EN_ON_DIST;
            this.WR_EN_ON_DIST = WR_EN_ON_DIST;
        endfunction
        //FIFO_1
        constraint reset_cons{
            rst_n dist {1:/90 , 0:/10};
        }
        //FIFO_2//FIFO_3//FIFO_4//FIFO_5//FIFO_6//FIFO_7//FIFO_8//FIFO_9//FIFO_10//FIFO_11//FIFO_12
        constraint write_en_cons{
            wr_en dist {1:/WR_EN_ON_DIST, 0:/(100-WR_EN_ON_DIST)};
        }
        constraint read_en_cons{
            rd_en dist {1:/RD_EN_ON_DIST, 0:/(100-RD_EN_ON_DIST)};
        }
    endclass
endpackage