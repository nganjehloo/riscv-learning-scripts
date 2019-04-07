#!/bin/bash
#UPDATE UTILITY FOR THE RISCV TOOLCHAIN

update(){
	echo "----UPDATING TOOLCHAIN----"
	cd $ROCKETCHIP
	git pull origin master
	cd $RISCV
	git pull origin master
	git submodule update --init --recursive
	git submodule update --init --recursive riscv-tests
	CC=gcc-5 CXX=g++-5 ./build.sh
	cd $TOP
	echo "----UPDATE COMPLETE----"
}
