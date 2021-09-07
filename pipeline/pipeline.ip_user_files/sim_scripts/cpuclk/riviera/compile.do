vlib work
vlib riviera

vlib riviera/xpm
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -sv2k12 "+incdir+../../../ipstatic" \
"D:/Applications/Vivado2020/Vivado/2019.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93 \
"D:/Applications/Vivado2020/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" \
"../../../../pipeline.srcs/sources_1/ip/cpuclk/cpuclk_clk_wiz.v" \
"../../../../pipeline.srcs/sources_1/ip/cpuclk/cpuclk.v" \

vlog -work xil_defaultlib \
"glbl.v"

