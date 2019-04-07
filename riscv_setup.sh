#!/bin/bash
#Setup script for riscv toolchain and chipset generator

clonerocketrepo(){
	git clone https://github.com/ucb-bar/rocket-chip.git	
	cd rocket-chip
	echo export ROCKETCHIP=$(pwd)
	export ROCKETCHIP=$(pwd)
	git submodule update --init	
	cd $TOP
}

preparetoolchain(){
	cd $ROCKETCHIP/riscv-tools/
	git submodule update --init --recursive
	export RISCV=$(pwd)
	echo export RISCV=$(pwd)
	git submodule update --init --recursive riscv-tests
	cd $TOP
}

buildtoolchain(){
	cd $RISCV
	CC=gcc-5 CXX=g++-5 ./build.sh
	cd $TOP
}

setup(){
	echo "----RISCV SETUP----"
	echo "THIS SETUP DOES THE FOLLOWING: "
	echo "-ASSUMES YOU HAVE NOT PREVIOUSLY INSTALLED ANY RISCV SOFTWARE"
	echo "-WILL ADD/MODIFY YOUR ENVIORNMENT VARIABLES!"
	echo "-ASSUMES YOU ARE RUNNING A LINUX DISTRO BASED ON DEBIAN (i.e Linux Mint, Ubuntu etc)"
	echo "-WILL INSTALL 64BIT RISCV TOOLS"
	echo "-ENSURE YOU HAVE A SEVERAL GB OF STORAGE AVAILABLE"
	echo "-DEPENDING ON YOUR SYSTEM THIS MAY TAKE SOME TIME"
	
	read -p "Continue? (Y/N)" yn
	if [[ ! "$yn" =~ ^[yY] ]]; then
		echo "EXITING SETUP"
		exit 1
	fi
	
	echo export TOP=$(pwd)
	export TOP=$(pwd)
	echo -e "\nCloning Repo.."
	clonerocketrepo

	echo -e "\nSpecify number of cpus for building, otherwise specify 0 to not modify MAKEFLAGS enviornment variable"
	read numcpus
	if [ "$numcpus" -gt "0" ]; then
		echo export MAKEFLAGS="$MAKEFLAGS -j$numcpus"
		export MAKEFLAGS="$MAKEFLAGS -j$numcpus"
	fi

	echo -e "\nInstalling Dependencies..."
	sudo apt-get install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev libusb-1.0-0-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev device-tree-compiler pkg-config libexpat-dev

	echo -e "\nPreparing Toolchain..."
	preparetoolchain

	echo -e "\nBuilding Toolchain..."
	buildtoolchain

	echo "----INSTALLATION COMPLETE----"
	cd $TOP
}
