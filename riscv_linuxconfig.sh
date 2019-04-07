#!/bin/bash/
#RISCV LINUX CONFIG Utility

makeXcompiler(){
	echo "****BUILDING CROSS COMPILER****"
	cd $RISCV/riscv-gnu-toolchain
	./configure --prefix=$RISCV
	make linux
	cd $TOP
	echo "****DONE Building CROSS COMPILER****"	
}

downloadkernel(){
	echo "****STARTING DOWNLOAD OF KERNEL****"
	cd $TOP
	VERSION=0;
	REVISION=0;
	read -p "Specify the kernel version (i.e. 1.x, 2.x, 3.x, 4.x keep the .x))" VERSION	
	read -p "Specify the kernel revision (i.e. 4.9.99, 3.18.100))"	REVISION
	git clone https://github.com/riscv/riscv-linux.git linux-$REVISION

        curl -L https://www.kernel.org/pub/linux/kernel/v$VERSION/linux-$REVISION.tar.xz | tar -xJkf -
	sudo apt-get install ncurses-dev
	echo "****DONE DOWNLOADING KERNEL****"
}

downloadfedora(){
	echo "****STARTING DOWNLOAD OF FEDORA****"
	cd $TOP
	VERSION=0;
	REVISION=0;
	mkdir riscv-fedora
	cd riscv-fedora
	sudo apt-get install unxz
        wget http://fedora-riscv.tranquillity.se/kojifiles/work/tasks/4544/104544/Fedora-Developer-Rawhide-20180908.n.0-sda.raw.xz
	unxz Fedora-Developer-Rawhide-20180908.n.0-sda.raw.xz
	wget https://fedorapeople.org/groups/risc-v/disk-images/bbl
	echo "****DONE DOWNLOADING FEDORA****"
}

configkerneldef(){
	echo "****CONFIGURING KERNEL****"
	cd $TOP
	REVISION=0;
	read -p "Specify the kernel revision (i.e. 4.9.99, 3.18.100))"	REVISION
	cd linux-$REVISION
	make ARCH=riscv defconfig
	echo "****DONE CONFIGURING KERNEL****"
}
configkernelcust(){
	echo "****CONFIGURING KERNEL****"
	cd $TOP
	REVISION=0;
	read -p "Specify the kernel revision (i.e. 4.9.99, 3.18.100))"	REVISION
	cd linux-$REVISION
	make ARCH=riscv menuconfig
	echo "****DONE CONFIGURING KERNEL****"
}

buildkernel(){
	echo "****BUILD KERNEL****"
	cd $TOP
	REVISION=0;
	read -p "Specify the kernel revision (i.e. 3.9.99, 3.18.100))"	REVISION
	cd $TOP/linux-$REVISION
	make $MAKEFLAGS ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-gnu-  

	echo "****DONE BUILDING KERNEL***"
}

downloadbusybox(){
	echo "****DOWNLOADING BUSYBOX****"
	cd $TOP
	REVISION=0;
	read -p "Specify the busybox revision (i.e. 1.26.2, 1.29.2))"	REVISION

	curl -L http://busybox.net/downloads/busybox-$REVISION.tar.bz2 > busybox-$REVISION.tar.bz2
	tar xvjf busybox-$REVISION.tar.bz2
	cd busybox-$REVISION
	make allnoconfig
	echo "****DONE DOWNLOADING BUSYBOX****"
}

configbusybox(){
	echo "****CONFIGURING BUSYBOX****"
	cd $TOP
	REVISION=0;
	read -p "Specify the busybox revision (i.e. 1.26.2, 1.29.2))"	REVISION
	cd busybox-$REVISION
	make menuconfig
	echo "****DONE CONFIGURING BUSYBOX****"
}

buildbusybox(){
	echo "****BUILDING BUSYBOX****"
	cd $TOP
	REVISION=0;
	read -p "Specify the busybox revision (i.e. 1.26.2, 1.29.2))"	REVISION
	cd busybox-$REVISION
	make $MAKEFLAGS
	echo "****DONE BUILDING BUSYBOX****"
}
createbootabledisk(){
	echo "****CREATING DISK****"
	cd $TOP
	REVISION=0;
	REVISIONBB=0;
	read -p "Specify the linux kernel revision (i.e. 4.9.99, 3.18.100))"	REVISION
	read -p "Specify the busybox revision (i.e. 1.26.2, 1.29.2))"	REVISIONBB
	cd linux-$REVISION
	mkdir root
	cd root
	mkdir -p bin etc dev lib proc sbin sys tmp usr usr/bin usr/lib usr/sbin
	cp $TOP/busybox-$REVISIONBB/busybox bin
	echo "::sysinit:/bin/busybox mount -t proc proc /proc" > etc/inittab
	echo "::sysinit:/bin/busybox mount -t tmpfs tmpfs /tmp" >> etc/inittab
	echo "::sysinit:/bin/busybox mount -o remount,rw /dev/htifblk0 /" >> etc/inittab
	echo "::sysinit:/bin/busybox --install -s" >> etc/inittab
	echo "/dev/console::sysinit:-/bin/ash" >> etc/inittab

	ln -s ../bin/busybox sbin/init
	ln -s sbin/init init

	sudo mknod dev/console c 5 1
		
	find . | cpio --quiet -o -c > ../rootfs.cpio
	cd ..
	sed -i 's/CONFIG_INITRAMFS_SOURCE=""/CONFIG_INITRAMFS_SOURCE="rootfs.cpio"/g' .config

	make $MAKEFLAGS ARCH=riscv vmlinux CROSS_COMPILE=riscv64-unknown-linux-gnu- 
	cd $RISCV/riscv-pk/build
	rm -rf *
	../configure --prefix=$RISCV --host=riscv64-unknown-linux-gnu --with-payload=$TOP/linux-$REVISION/vmlinux

	make 

	make install

	
	echo "****DONE CREATING DISK****"
}

linconfig(){
	cd $ROCKETCHIP
	echo "----BUILD LINUX----"
	echo "This Installation requires you to have a JDK installed"
	OPTION=0
	while [ "$OPTION" != "B"  ]; do
		echo "Please Choose from the options below:"
		echo "1) Build RISCV/Linux Cross Compiler"
		echo "2) Download a prebuilt linux image"
		echo "3) Download A Linux Kernel Of Your Choice"
		echo "4) Set default configuration for linux kernel"
		echo "5) Set custom configuration for linux kernel"
		echo "6) Build the linux kernel"
		echo "7) Download linux necessary linux utilities (Busybox)"
		echo "8) Configure Busybox"
		echo "9) Build Busybox"
		echo "10) Create bootable linux disk"
		echo "B) Go Back"
		
		read -p "What do you want to do?: " OPTION
		clear
		case $OPTION in
			"1") makeXcompiler
			;;
			"2") downloadfedora
			;;
			"3") downloadkernel
			;;
			"4") configkerneldef
			;;
			"5") configkernelcust
			;;
			"6") buildkernel
			;;
			"7") downloadbusybox
			;;
			"8") configbusybox
			;;
			"9") buildbusybox
			;;
			"10") createbootabledisk
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
