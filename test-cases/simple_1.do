add wave -position insertpoint  \
sim:/cpu/bidir \
sim:/cpu/rst \
sim:/cpu/clk \
sim:/cpu/r0out \
sim:/cpu/r1out \
sim:/cpu/r2out \
sim:/cpu/r3out \
sim:/cpu/r4out \
sim:/cpu/r5out \
sim:/cpu/r6out \
sim:/cpu/r7out \
sim:/cpu/destout \
sim:/cpu/sourceout \
sim:/cpu/mdrout \
sim:/cpu/mdrin \
sim:/cpu/mdr_load \
sim:/cpu/marout \
sim:/cpu/irout \
sim:/cpu/flagout \
sim:/cpu/flagin \
sim:/cpu/src_dec \
sim:/cpu/dst_dec \
sim:/cpu/ram_data_out \
sim:/cpu/wr \
sim:/cpu/rd \
sim:/cpu/s1 \
sim:/cpu/s3 \
sim:/cpu/s4 \
sim:/cpu/s5 \
sim:/cpu/s6 \
sim:/cpu/s7 \
sim:/cpu/s2 \
sim:/cpu/source_out_temp \
sim:/cpu/source_in_temp \
sim:/cpu/dest_out_temp \
sim:/cpu/dest_in_temp \
sim:/cpu/Rsrc_out_temp \
sim:/cpu/Rsrc_in_temp \
sim:/cpu/Rdst_out_temp \
sim:/cpu/Rdst_in_temp \
sim:/cpu/source_out \
sim:/cpu/source_in \
sim:/cpu/dest_out \
sim:/cpu/dest_in \
sim:/cpu/Rsrc_out \
sim:/cpu/Rsrc_in \
sim:/cpu/Rdst_out \
sim:/cpu/Rdst_in \
sim:/cpu/setflagout \
sim:/cpu/AluCFout \
sim:/cpu/AluZFout \
sim:/cpu/Rsrc_out_dec_out \
sim:/cpu/Rsrc_in_dec_out \
sim:/cpu/Rdst_out_dec_out \
sim:/cpu/Rdst_in_dec_out \
sim:/cpu/reg_tri_enable \
sim:/cpu/reg_load \
sim:/cpu/PCenable \
sim:/cpu/AluB \
sim:/cpu/zout \
sim:/cpu/yout \
sim:/cpu/zin \
sim:/cpu/NopA \
sim:/cpu/ADDD \
sim:/cpu/ADC \
sim:/cpu/SUB \
sim:/cpu/SBC \
sim:/cpu/ANDD \
sim:/cpu/ORR \
sim:/cpu/XNORR \
sim:/cpu/IncA \
sim:/cpu/DecA \
sim:/cpu/Clear \
sim:/cpu/NotB \
sim:/cpu/LSR_B \
sim:/cpu/ROR_B \
sim:/cpu/RRC_B \
sim:/cpu/ASR_B \
sim:/cpu/LSL_B \
sim:/cpu/ROL_B \
sim:/cpu/RLC_B \
sim:/cpu/AluAdd \
sim:/cpu/AluIncA \
sim:/cpu/AluDecA \
sim:/cpu/PCin \
sim:/cpu/PCincOut \
sim:/cpu/PCload \
sim:/cpu/offset
force -freeze sim:/cpu/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/cpu/rst 1 0
force -freeze sim:/cpu/r0out 0000000000000011 0

run

force -freeze sim:/cpu/rst 0 0

run -all