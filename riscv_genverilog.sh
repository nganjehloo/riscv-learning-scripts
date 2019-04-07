#!/bin/bash/
#VERILOG CODE GENERATOR

defaultconfig(){
	echo "****GENERATING VERILOG****"
	cd $ROCKETCHIP/vsim
	make verilog
	cd $TOP
	echo "****DONE GENERATING VERILOG****"
}

customconfig(){
	echo "****GENERATING VERILOG****"
	cd $ROCKETCHIP/vsim
	echo -e "Please enter the name of your custom configuration. (i.e DefaultFPGAConfig, DefaultSmallConfig etc)i: \n"
	read myconfig
	make verilog CONFIG=$myconfig
	cd $TOP
	echo "****DONE GENERATING VERILOG****"

}

genverilog(){
	echo "----VERILOG GENERATOR----"
	OPTION=0
	while [ "$OPTION" != "B"  ]; do
		echo "Please Choose from the options below:"
		echo "1) Generate default rocket chip verilog"
		echo "2) Generate your custom rocket chip verilog"
		echo "B) Go Back..."
		read -p "What do you want to do?: " OPTION
		clear
		case $OPTION in
			"1") defaultconfig
			;;
			"2") customconfig
			;;
			"B") echo "Going back to main menu..."
			;;
			*) echo "Not a valid input, Try Again"
			;;
		esac
	done
	echo "----DONE WITH VERILOG GENERATOPR----"
}
