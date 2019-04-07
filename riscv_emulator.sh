#!/bin/bash/
#VERILOG CODE GENERATOR

defaultverilator(){
	cd $ROCKETCHIP/emulator
	read -p "Please enter the number of cpus on this system to speed up building: " numcpus
	make -j$numcpus run
	cd $TOP
}

defaultVCS(){
	cd $ROCKETCHIP/vsim
	ruad -p "Please enter the number of cpus on this system to speed up building: " numcpus
	make -j$numcpus run CONFIG=DefaultFPGAConfig
	cd $TOP
}

customverilator(){
	echo "TODO"
}

customVCS(){
	echo "TODO"
}

runlinuxverilator(){
	echo "TODO"
}

runlinuxVCS(){
	echo "TODO"
}

defaultspike(){
	echo "****RUNNING SPIKE TEST****"
#	echo export PK=$RISCV/riscv64-unknown-elf/bin/
	export PK=$RISCV/riscv64-unknown-elf/bin
	cd $RISCV/bin/
	echo -e '#include <stdio.h>\n int main(void) { printf("Hello RISCV!\\n"); return 0; }' > hello.c
	./riscv64-unknown-elf-gcc -o hello hello.c
	echo "****Program Start****"
	./spike $PK/pk hello
	echo "****DONE RUNNING SPIKE****"
}

customspike(){
	echo "****RUNNING SPIKE****"
	cd $RISCV/bin/
	echo export PK=$RISCV/riscv64-unknown-elf/bin/
	export PK=$RISCV/riscv64-unknown-elf/bin/

	echo -e "Please enter the path to your C program: \n"
	read codepath
	echo -e "Please enter the program name: \n"
	read prgname
	./riscv64-unknown-elf-gcc -o $prgname $codepath
	spike $PK/pk $prgname
	echo "****DONE RUNNING SPIKE****"

}

runlinuxspike(){
	spike bbl vmlinux
}

runqemu(){
	echo "****RUNNING QEMU****"
	cd $TOP/riscv-fedora
	qemu-system-riscv64 \
    -nographic \
    -machine virt \
    -m 2G \
    -kernel bbl \
    -object rng-random,filename=/dev/urandom,id=rng0 \
    -device virtio-rng-device,rng=rng0 \
    -append "console=ttyS0 ro root=/dev/vda1" \
    -device virtio-blk-device,drive=hd0 \
    -drive file=Fedora-Developer-Rawhide-20180908.n.0-sda.raw,format=raw,id=hd0 \
    -device virtio-net-device,netdev=usernet \
    -netdev user,id=usernet,hostfwd=tcp::10000-:22
	echo "****DONE RUNNING QEMU****"
}

emulate(){
	echo "----RISCV EMULATOR----"
	OPTION=0
	while [ "$OPTION" != "B"  ]; do
		echo "Please Choose from the options below:"
		echo "1) Run included tests using fast C emulator (Verilator)"
		echo "2) Run included tests using Synopsys VCS (Make sure you have this)"
		echo "3) Run custom code using fast C emulator (Verilator)"
		echo "4) Run custom code using Synopsys VCS (Make sure you have this)"
		echo "5) Run configured linux distro using fast C emulator (Verilator)"
		echo "6) Run configured linux distro using Synopsys VCS (Make sure you have this)"
		echo "7) Run Spike Simulator (Lower Accuracy)"
		echo "8) Run Custom Code On Spike Simulator (Lower Accuracy)"
		echo "9) Run configured linux distro using Spike Simulator (Lower Accuracy)"
		echo "10) Run linux on QEMU (lowest accuracy)"
		echo "B) Go Back..."
		read -p "What do you want to do?: " OPTION
		clear
		case $OPTION in
			"1") defaultverilator
			;;
			"2") defaultVCS
			;;
			"3") customverilator
			;;
			"4") customVCS
			;;
			"5") runlinuxverilator
			;;
			"6") runlinuxVCS
			;;
			"7") defaultspike
			;;
			"8") customspike
			;;
			"9") runlinuxspike
			;;
			"10") runqemu
			;;
			"B") echo "Going back to main menu..."
			;;
			*) echo "Not a valid input, Try Again"
			;;
		esac
	done
	echo "----DONE EMULATING----"
}
