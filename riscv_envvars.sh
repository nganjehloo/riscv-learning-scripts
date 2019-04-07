#!/bin/bash

setenv(){
	echo ****SETTING ENVIORNMENT VARIABLES****
	echo -e "\nSpecify number of cpus for building, otherwise specify 0 to not modify MAKEFLAGS enviornment variable"
	read numcpus
	if [ "$numcpus" -gt "0" ]; then
		echo export MAKEFLAGS="$MAKEFLAGS -j$numcpus"
		export MAKEFLAGS="$MAKEFLAGS -j$numcpus"
	fi

	export TOP=$(pwd)
	export ROCKETCHIP=$(pwd)/rocket-chip
	export RISCV=$ROCKETCHIP/riscv-tools
	export PK=$RISCV/riscv64-unknown-elf/bin
	export PATH=$PATH:$RISCV/bin

	echo $TOP
	echo $ROCKETCHIP
	echo $RISCV	
	echo $PK
	echo $PATH
	echo ****DONE SETTING ENVIORNMENT VARIABLES****
}

