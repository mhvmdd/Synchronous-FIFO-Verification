////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_if f_if);
 
localparam max_fifo_addr = $clog2(f_if.FIFO_DEPTH);

reg [f_if.FIFO_WIDTH-1:0] mem [f_if.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge f_if.clk or negedge f_if.rst_n) begin
	if (!f_if.rst_n) begin
		wr_ptr <= 0;
		f_if.overflow <= 0;
		f_if.wr_ack <= 0; 
	end
	else if (f_if.wr_en && count < f_if.FIFO_DEPTH) begin
		mem[wr_ptr] <= f_if.data_in;
		f_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		f_if.wr_ack <= 0; 
		if (f_if.full & f_if.wr_en)
			f_if.overflow <= 1;
		else
			f_if.overflow <= 0;
	end
end

always @(posedge f_if.clk or negedge f_if.rst_n) begin
	if (!f_if.rst_n) begin
		rd_ptr <= 0;
		f_if.underflow <= 0;
	end
	else if (f_if.rd_en && count != 0) begin
		f_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	else begin
		if (f_if.empty & f_if.rd_en)
			f_if.underflow <= 1;
		else
			f_if.underflow <= 0;
	end
end

always @(posedge f_if.clk or negedge f_if.rst_n) begin
	if (!f_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({f_if.wr_en, f_if.rd_en} == 2'b11) && f_if.full) 
			count <= count - 1;
		else if ( ({f_if.wr_en, f_if.rd_en} == 2'b11) && f_if.empty)
			count <= count + 1;
		else if	( ({f_if.wr_en, f_if.rd_en} == 2'b10) && !f_if.full) 
			count <= count + 1;
		else if ( ({f_if.wr_en, f_if.rd_en} == 2'b01) && !f_if.empty)
			count <= count - 1;
	end
end

assign f_if.full = (count == f_if.FIFO_DEPTH)? 1 : 0; 
assign f_if.empty = (count == 0)? 1 : 0;
assign f_if.almostfull = (count == f_if.FIFO_DEPTH-1)? 1 : 0; 	
assign f_if.almostempty = (count == 1)? 1 : 0;

`ifdef SIM
//Assertions
//a
//FIFO_1
a_resetBehaviour: assert property (@(posedge f_if.clk) !f_if.rst_n |-> !wr_ptr && !rd_ptr && !count);
a_resetBehaviour_cvr: cover property (@(posedge f_if.clk) !f_if.rst_n |-> !wr_ptr && !rd_ptr && !count);
//b
//FIFO_3//FIFO_4//FIFO_5//FIFO_10//FIFO_11//FIFO_12
a_wr_ack: assert property (@(posedge f_if.clk) disable iff (!f_if.rst_n) f_if.wr_en && !f_if.full  |-> ##1 f_if.wr_ack);
a_wr_ack_cvr: cover property (@(posedge f_if.clk) disable iff (!f_if.rst_n) f_if.wr_en && !f_if.full  |-> ##1 f_if.wr_ack);
//c
//FIFO_5, FIFO_12
a_overflow: assert property (@(posedge f_if.clk) disable iff (!f_if.rst_n) 	f_if.full && f_if.wr_en |-> ##1 f_if.overflow);
a_overflow_cvr: cover property (@(posedge f_if.clk) disable iff (!f_if.rst_n) 	f_if.full && f_if.wr_en |-> ##1 f_if.overflow);
//d
//FIFO_9, FIFO_11
a_underflow: assert property (@(posedge f_if.clk) disable iff (!f_if.rst_n) 	f_if.empty && f_if.rd_en |->##1 f_if.underflow);
a_underflow_cvr: cover property (@(posedge f_if.clk) disable iff (!f_if.rst_n) 	f_if.empty && f_if.rd_en |->##1 f_if.underflow);
//e
//FIFO_8, FIFO_9
a_empty: assert property (@(posedge f_if.clk) 	!count |-> f_if.empty);
a_empty_cvr: cover property (@(posedge f_if.clk) 	!count |-> f_if.empty);
//f
//FIFO_4, FIFO_5
a_full: assert property (@(posedge f_if.clk) disable iff (!f_if.rst_n) 	count == f_if.FIFO_DEPTH |-> f_if.full);
a_full_cvr: cover property (@(posedge f_if.clk) disable iff (!f_if.rst_n) 	count == f_if.FIFO_DEPTH |-> f_if.full);
//g
//FIFO_3, FIFO_12
a_almostfull: assert property (@(posedge f_if.clk) disable iff (!f_if.rst_n) 	count == f_if.FIFO_DEPTH-1 |-> f_if.almostfull);
a_almostfull_cvr: cover property (@(posedge f_if.clk) disable iff (!f_if.rst_n) 	count == f_if.FIFO_DEPTH-1 |-> f_if.almostfull);
//h
//FIFO_11, FIFO_7
a_almostempty: assert property (@(posedge f_if.clk) disable iff (!f_if.rst_n) 	count == 1 |-> f_if.almostempty);
a_almostempty_cvr: cover property (@(posedge f_if.clk) disable iff (!f_if.rst_n) 	count == 1 |-> f_if.almostempty);

//i 
//read pointer
a_rd_ptr_wrap: assert property (@(posedge f_if.clk) disable iff (!f_if.rst_n) rd_ptr == f_if.FIFO_DEPTH-1 && f_if.rd_en && !f_if.empty |-> ##1 rd_ptr == 0);
a_rd_ptr_wrap_cvr: cover property (@(posedge f_if.clk) disable iff (!f_if.rst_n) rd_ptr == f_if.FIFO_DEPTH-1 && f_if.rd_en && !f_if.empty |-> ##1 rd_ptr == 0);
//write pointer
a_wr_ptr_wrap: assert property (@(posedge f_if.clk) disable iff (!f_if.rst_n) wr_ptr == f_if.FIFO_DEPTH-1 && f_if.wr_en && !f_if.full |-> ##1 wr_ptr == 0);
a_wr_ptr_wrap_cvr: cover property (@(posedge f_if.clk) disable iff (!f_if.rst_n) wr_ptr == f_if.FIFO_DEPTH-1 && f_if.wr_en && !f_if.full |-> ##1 wr_ptr == 0);

//j
always_comb begin
	if (f_if.rst_n) begin
		a_rd_ptr_thr: assert final (rd_ptr < f_if.FIFO_DEPTH);
		a_wr_ptr_thr: assert final (wr_ptr < f_if.FIFO_DEPTH);
		a_count_thr: assert final (count <= f_if.FIFO_DEPTH);
	end
end

`endif
endmodule