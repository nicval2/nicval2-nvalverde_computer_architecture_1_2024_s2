transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {e:/quartus/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {e:/quartus/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {e:/quartus/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {e:/quartus/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {e:/quartus/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cyclonev_ver
vmap cyclonev_ver ./verilog_libs/cyclonev_ver
vlog -vlog01compat -work cyclonev_ver {e:/quartus/quartus/eda/sim_lib/mentor/cyclonev_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {e:/quartus/quartus/eda/sim_lib/mentor/cyclonev_hmi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {e:/quartus/quartus/eda/sim_lib/cyclonev_atoms.v}

vlib verilog_libs/cyclonev_hssi_ver
vmap cyclonev_hssi_ver ./verilog_libs/cyclonev_hssi_ver
vlog -vlog01compat -work cyclonev_hssi_ver {e:/quartus/quartus/eda/sim_lib/mentor/cyclonev_hssi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_hssi_ver {e:/quartus/quartus/eda/sim_lib/cyclonev_hssi_atoms.v}

vlib verilog_libs/cyclonev_pcie_hip_ver
vmap cyclonev_pcie_hip_ver ./verilog_libs/cyclonev_pcie_hip_ver
vlog -vlog01compat -work cyclonev_pcie_hip_ver {e:/quartus/quartus/eda/sim_lib/mentor/cyclonev_pcie_hip_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_pcie_hip_ver {e:/quartus/quartus/eda/sim_lib/cyclonev_pcie_hip_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/memoryController.sv}
vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/dmem_ram.sv}
vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/SEGMENTATION {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/SEGMENTATION/segment_ex_mem.sv}
vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/MUX {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/MUX/mux_4.sv}
vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/MUX {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/MUX/mux_2.sv}
vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/ALU {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/ALU/alu.sv}
vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/ADDER {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/ADDER/adder.sv}
vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/CONTROL_UNIT {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/CONTROL_UNIT/control_unit.sv}
vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/PC_REG {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/PC_REG/pc_register.sv}
vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/ID_STAGE {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/ID_STAGE/sign_extend.sv}
vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/JUMP_UNIT {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/JUMP_UNIT/jump_unit.sv}
vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/SEGMENTATION {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/SEGMENTATION/segment_id_ex.sv}
vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/SEGMENTATION {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/SEGMENTATION/segment_if_id.sv}
vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/SEGMENTATION {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/SEGMENTATION/segment_mem_wb.sv}
vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/REG_FILE {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/REG_FILE/register_file.sv}
vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/pipeline.sv}
vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/memoryAccess.sv}
vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/imem.sv}
vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/dmem_rom.sv}

vlog -sv -work work +incdir+D:/.TEC/Arquitectura\ de\ Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor {D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/pipeline_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  pipeline_tb

add wave *
view structure
view signals
run -all
