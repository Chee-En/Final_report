# This file is automatically generated.
# It contains project source information necessary for synthesis and implementation.

# XDC: new/uart.xdc

# Block Designs: bd/design_1/design_1.bd
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==design_1 || ORIG_REF_NAME==design_1} -quiet] -quiet

# IP: bd/design_1/ip/design_1_processing_system7_0_0/design_1_processing_system7_0_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==design_1_processing_system7_0_0 || ORIG_REF_NAME==design_1_processing_system7_0_0} -quiet] -quiet

# IP: bd/design_1/ip/design_1_axi_uartlite_0_0/design_1_axi_uartlite_0_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==design_1_axi_uartlite_0_0 || ORIG_REF_NAME==design_1_axi_uartlite_0_0} -quiet] -quiet

# IP: bd/design_1/ip/design_1_ps7_0_axi_periph_0/design_1_ps7_0_axi_periph_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==design_1_ps7_0_axi_periph_0 || ORIG_REF_NAME==design_1_ps7_0_axi_periph_0} -quiet] -quiet

# IP: bd/design_1/ip/design_1_rst_ps7_0_50M_0/design_1_rst_ps7_0_50M_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==design_1_rst_ps7_0_50M_0 || ORIG_REF_NAME==design_1_rst_ps7_0_50M_0} -quiet] -quiet

# IP: bd/design_1/ip/design_1_xbar_0/design_1_xbar_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==design_1_xbar_0 || ORIG_REF_NAME==design_1_xbar_0} -quiet] -quiet

# IP: bd/design_1/ip/design_1_simple_filter_0_0/design_1_simple_filter_0_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==design_1_simple_filter_0_0 || ORIG_REF_NAME==design_1_simple_filter_0_0} -quiet] -quiet

# IP: bd/design_1/ip/design_1_axi_gpio_0_0/design_1_axi_gpio_0_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==design_1_axi_gpio_0_0 || ORIG_REF_NAME==design_1_axi_gpio_0_0} -quiet] -quiet

# IP: bd/design_1/ip/design_1_axi_gpio_0_1/design_1_axi_gpio_0_1.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==design_1_axi_gpio_0_1 || ORIG_REF_NAME==design_1_axi_gpio_0_1} -quiet] -quiet

# IP: bd/design_1/ip/design_1_blk_mem_gen_0_8/design_1_blk_mem_gen_0_8.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==design_1_blk_mem_gen_0_8 || ORIG_REF_NAME==design_1_blk_mem_gen_0_8} -quiet] -quiet

# IP: bd/design_1/ip/design_1_axi_bram_ctrl_0_4/design_1_axi_bram_ctrl_0_4.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==design_1_axi_bram_ctrl_0_4 || ORIG_REF_NAME==design_1_axi_bram_ctrl_0_4} -quiet] -quiet

# IP: bd/design_1/ip/design_1_auto_pc_3/design_1_auto_pc_3.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==design_1_auto_pc_3 || ORIG_REF_NAME==design_1_auto_pc_3} -quiet] -quiet

# IP: bd/design_1/ip/design_1_auto_pc_0/design_1_auto_pc_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==design_1_auto_pc_0 || ORIG_REF_NAME==design_1_auto_pc_0} -quiet] -quiet

# IP: bd/design_1/ip/design_1_auto_pc_1/design_1_auto_pc_1.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==design_1_auto_pc_1 || ORIG_REF_NAME==design_1_auto_pc_1} -quiet] -quiet

# IP: bd/design_1/ip/design_1_auto_pc_2/design_1_auto_pc_2.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==design_1_auto_pc_2 || ORIG_REF_NAME==design_1_auto_pc_2} -quiet] -quiet

# XDC: bd/design_1/ip/design_1_processing_system7_0_0/design_1_processing_system7_0_0.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==design_1_processing_system7_0_0 || ORIG_REF_NAME==design_1_processing_system7_0_0} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: bd/design_1/ip/design_1_axi_uartlite_0_0/design_1_axi_uartlite_0_0_board.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==design_1_axi_uartlite_0_0 || ORIG_REF_NAME==design_1_axi_uartlite_0_0} -quiet] {/U0 } ]/U0 ] -quiet] -quiet

# XDC: bd/design_1/ip/design_1_axi_uartlite_0_0/design_1_axi_uartlite_0_0_ooc.xdc

# XDC: bd/design_1/ip/design_1_axi_uartlite_0_0/design_1_axi_uartlite_0_0.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==design_1_axi_uartlite_0_0 || ORIG_REF_NAME==design_1_axi_uartlite_0_0} -quiet] {/U0 } ]/U0 ] -quiet] -quiet

# XDC: bd/design_1/ip/design_1_rst_ps7_0_50M_0/design_1_rst_ps7_0_50M_0_board.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==design_1_rst_ps7_0_50M_0 || ORIG_REF_NAME==design_1_rst_ps7_0_50M_0} -quiet] {/U0 } ]/U0 ] -quiet] -quiet

# XDC: bd/design_1/ip/design_1_rst_ps7_0_50M_0/design_1_rst_ps7_0_50M_0.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==design_1_rst_ps7_0_50M_0 || ORIG_REF_NAME==design_1_rst_ps7_0_50M_0} -quiet] {/U0 } ]/U0 ] -quiet] -quiet

# XDC: bd/design_1/ip/design_1_axi_gpio_0_0/design_1_axi_gpio_0_0_board.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==design_1_axi_gpio_0_0 || ORIG_REF_NAME==design_1_axi_gpio_0_0} -quiet] {/U0 } ]/U0 ] -quiet] -quiet

# XDC: bd/design_1/ip/design_1_axi_gpio_0_0/design_1_axi_gpio_0_0_ooc.xdc

# XDC: bd/design_1/ip/design_1_axi_gpio_0_0/design_1_axi_gpio_0_0.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==design_1_axi_gpio_0_0 || ORIG_REF_NAME==design_1_axi_gpio_0_0} -quiet] {/U0 } ]/U0 ] -quiet] -quiet

# XDC: bd/design_1/ip/design_1_axi_gpio_0_1/design_1_axi_gpio_0_1_board.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==design_1_axi_gpio_0_1 || ORIG_REF_NAME==design_1_axi_gpio_0_1} -quiet] {/U0 } ]/U0 ] -quiet] -quiet

# XDC: bd/design_1/ip/design_1_axi_gpio_0_1/design_1_axi_gpio_0_1_ooc.xdc

# XDC: bd/design_1/ip/design_1_axi_gpio_0_1/design_1_axi_gpio_0_1.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==design_1_axi_gpio_0_1 || ORIG_REF_NAME==design_1_axi_gpio_0_1} -quiet] {/U0 } ]/U0 ] -quiet] -quiet

# XDC: bd/design_1/ip/design_1_blk_mem_gen_0_8/design_1_blk_mem_gen_0_8_ooc.xdc

# XDC: bd/design_1/ip/design_1_auto_pc_3/design_1_auto_pc_3_ooc.xdc

# XDC: bd/design_1/ip/design_1_auto_pc_0/design_1_auto_pc_0_ooc.xdc

# XDC: bd/design_1/ip/design_1_auto_pc_1/design_1_auto_pc_1_ooc.xdc

# XDC: bd/design_1/ip/design_1_auto_pc_2/design_1_auto_pc_2_ooc.xdc

# XDC: bd/design_1/design_1_ooc.xdc
