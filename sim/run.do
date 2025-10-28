# 1. Setup and Compile with coverage enabled
vlib work
vlog -f src_files.list +cover -covercells +define+SIM

# 2. Start simulation
vsim -voptargs=+acc work.top -classdebug -cover

# 3. Add waves for debugging 
add wave /top/f_if/*
add wave -position insertpoint  \
    sim:/top/DUT/mem \
    sim:/top/DUT/wr_ptr \
    sim:/top/DUT/rd_ptr \
    sim:/top/DUT/count
add wave -position insertpoint  \
    sim:/top/MONITOR/F_txn
add wave -position end  sim:/top/MONITOR/F_scrbrd
add wave -position end  sim:/top/MONITOR/F_cvg
add wave -position insertpoint  \
    sim:/shared_pkg::error_cnt \
    sim:/shared_pkg::correct_cnt


# 5. Save the collected coverage data to a file
coverage save FIFO.ucdb -onexit


# 4. Run the simulation to completion
run -all


coverage exclude -cvgpath {/FIFO_coverage_pkg/FIFO_coverage/FIFO_cvr/cross_full/<auto[1],auto[1],auto[1]>}
coverage exclude -cvgpath {/FIFO_coverage_pkg/FIFO_coverage/FIFO_cvr/cross_full/<auto[0],auto[1],auto[1]>}
coverage exclude -cvgpath {/FIFO_coverage_pkg/FIFO_coverage/FIFO_cvr/cross_overflow/<auto[0],auto[1],auto[1]>}
coverage exclude -cvgpath {/FIFO_coverage_pkg/FIFO_coverage/FIFO_cvr/cross_overflow/<auto[0],auto[0],auto[1]>}
coverage exclude -cvgpath {/FIFO_coverage_pkg/FIFO_coverage/FIFO_cvr/cross_underflow/<auto[1],auto[0],auto[1]>}
coverage exclude -cvgpath {/FIFO_coverage_pkg/FIFO_coverage/FIFO_cvr/cross_underflow/<auto[0],auto[0],auto[1]>}
coverage exclude -cvgpath {/FIFO_coverage_pkg/FIFO_coverage/FIFO_cvr/cross_write_ack/<auto[0],auto[1],auto[1]>}
coverage exclude -cvgpath {/FIFO_coverage_pkg/FIFO_coverage/FIFO_cvr/cross_write_ack/<auto[0],auto[0],auto[1]>}