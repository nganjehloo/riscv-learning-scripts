#!/bin/bash
#RISCV TOOLCHAIN PROGRAM. MORE EASILY USE AND SETUP TOOLS.
#****CHANGE_LOG****

#Nima Ganjehloo 6/1/2018
#Initial script for setting up basic rocket chip

#Nima Ganjehloo 6/10/2018
#Added boomv2 setup in initial script

#Nima Ganjehloo 6/27/2018
#Removed boomv2 setup, stick with inorder rocket core for now
#Added menu script
#Added Update script

#Nima Ganjehloo 6/28/2018
#Added Build Simulator script
#Added Verilog Generator script

#Nima Ganjehloo 6/30/2018
#Added basic configuration support for verilog generator

#Nima Ganjehloo 7/1/2018
#Added emulator script
#Added custom C code compilation within emulator script. make this seperate later


#****TODO****
#Add Rocket Chip customization script (look more into what this would entail)
#--I can add a custom chisel config file to do this. ucb has a config. worry about this much later on after adding benchmarking and simple paramaters for cache
#--Custom Instructions (Easier to do for Spike than Verilator, do Spike first)
#Add Compiler script to more easily compile custom code
#--llvm support? There is a risc-v port. Need to check how to properly integrate (worry about later, before or after adding boom?)
#Add Support for custom code on cycle accurate emulators
#Streamline Emulator script to run custom code
#Add custom benchmark script for cycle accurate emulators
#Add GDB Support for emulator
#Add linux setup script
#Add On Chip Debugger support for FPGA(probably the very last thing)

#"include files....lol"
. ./riscv_envvars.sh
. ./riscv_setup.sh
. ./riscv_updatetools.sh
. ./riscv_parametrize.sh
. ./riscv_buildsim.sh
. ./riscv_genverilog.sh
. ./riscv_compiler.sh
. ./riscv_linuxconfig.sh
. ./riscv_emulator.sh

echo "**********************************"
echo "-        RISCV TOOLCHAIN         -"
echo "**********************************"
echo "NOTE: Please run this script from the root directory of your intended riscv project"	
echo -e "NOTE: Reccomended steps for first run is 1,2,3,5 inorder"
	
RUN=0
while [ "$RUN" != "Q"  ]; do
	echo "Please Choose from the options below:"
	echo "1) Initial Setup ( Do this first if you are just starting )"
	echo "2) Update Toolchain"
	echo "3) Build Simulators (Builds C++/Verilog cycle accurate emulators)"
	echo "4) Generate Verilog For VCS (Use if using VCS instead of Verilator or if using FPGA)"
	echo "5) Setup custom RISCV linux build for emulators"
	echo "6) Run Emulators (Simulate currently configured chip with different emulators)"
	echo "E) Set required enviornment variables"
	echo "Q) Quit"
	read -p "What do you want to do?: " RUN
	clear
	case $RUN in
		"1") setup
		;;
		"2") update
		;;
		"3") buildsim
		;;
		"4") genverilog
		;;
		"5") linconfig
		;;
		"6") emulate
		;;
		"E") setenv
		;;
		"Q") echo "Quitting..."
		;;
		*) echo "Not a valid input, Try Again"
		;;
	esac
done
exit 1
