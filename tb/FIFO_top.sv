module top;
    bit clk = 0;

    initial forever #1 clk = ~clk;

    FIFO_if f_if (clk);

    FIFO DUT (f_if.dut);         

    FIFO_tb TB (f_if.test);      

    FIFO_monitor MONITOR (f_if.monitor);  

//FIFO_1
    always_comb begin
        if (!f_if.rst_n) begin
            a_reset_1: assert final (f_if.empty && !f_if.full);
            a_reset_2: assert final (!f_if.almostempty && !f_if.almostfull);
            a_reset_3: assert final (!f_if.overflow && !f_if.underflow);
        end
    end

endmodule 

