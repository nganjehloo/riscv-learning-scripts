#!/bin/bash/
#Simulator Installation Utility

csim(){
	echo "****BUILDING C SIMULATOR****"
	cd emulator
	make
	echo "****DONE Building C SIMULATOR****"	
}

buildspike(){
	echo "****BUILDING SPIKE SIMULATOR****"
	cd $RISCV/riscv-isa-sim/build
	rm -rf *
	../configure --prefix=$RISCV --with-fesvr=$RISCV
	make
	sudo make install
	echo "****DONE BUILDING SPIKE SIMULATOR****"
}

debugcsim(){
	echo "****BUILDING DEBUG C SIMULATOR****"
	cd emulator
	make debug
	echo "****DONE Building DEBUG C SIMULATOR****"
}

vcssim(){
	echo "****BUILDING VCS SIMULATOR****"
	cd vsim
	make verilog
	echo "****DONE Building VCS SIMULATOR****"
}

buildqemu(){
	echo "****BUILDING QEMU****"
	cd $RISCV/riscv-gnu-toolchain
	sudo apt-get install libglib2.0-dev
	sudo apt-get install libpixman-1-dev
	git clone https://github.com/qemu/qemu.git
	cd qemu
	./configure --target-list=riscv64-softmmu,riscv64-linux-user
	sudo make -j$MAKEFLAGS
	sudo make install
}


buildsim(){
	cd $ROCKETCHIP
	echo "----BUILD SIMULATOR----"
	echo "This Installation requires you to have a JDK installed"
	OPTION=0
	while [ "$OPTION" != "B"  ]; do
		echo "Please Choose from the options below:"
		echo "1) Build C Simulator"
		echo "2) Build VCS Simulator"
		echo "3) Build Debug C Simulator (has waveforms for VCS)"
		echo "4) Build QEMU"
		echo "5) Build Spike"
		echo "B) Go Back"
		
		read -p "What do you want to do?: " OPTION
		clear
		case $OPTION in
			"1") csim
			;;
			"2") vcssim
			;;
			"3") debugcsim
			;;
			"4") buildqemu
			;;
			"5") buildspike
			;;
			"B") echo "Going back to main menu..."
			OPTION = "B"
			;;
			*) echo "Not a valid input, Try Again"
			;;
		esac
	done
	cd $TOP
	echo "----DONE BUILDING SIMULATORS----"	
}
