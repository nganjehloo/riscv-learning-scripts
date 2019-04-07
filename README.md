# riscv-tools-scripts
A set of scripts that makes working with riscv easier

----

## RISCV Pre-Requisites
1) Make sure you have GCC version greater than or equal to 4.8 C++11
2) Make sure you have a recent version of both the jdk and jre installed on your machine
3) You will also need the following packages
   * Ubuntu: `sudo apt-get install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev libusb-1.0-0-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev device-tree-compiler pkg-config libexpat-dev ncurses-dev gcc-5 g++-5 jimsh python unxz libglib2.0-dev libpixman-1-dev`
   * Fedora: `sudo dnf install autoconf automake @development-tools curl dtc libmpc-devel mpfr-devel gmp-devel libusb-devel gawk gcc-c++ build-essential bison flex texinfo gperf libtool patchutils bc zlib-devel device-tree-compiler pkg-config expat-devel ncurses-dev gcc-5 g++-5 jimsh python unxz libglib2.0-dev libpixman-1-dev`
   * Other: You must install all of the equivalent packages for your distro assuming you are not running an ubuntu based or fedora based forked distro
4) More than 13GB of free storage space

---

## Using The Scripts
### Script First Time Use

1. Clone this repo into an empty directory
1. Run the riscv_tool.sh script in the clone directory(the directory you cloned into)
    Add executable permission to all files by running the following:
    
    `chmod +x *.sh`

2. In the main menu select option 1 to install necessary riscv files
3. In the main menu select option 2 to update all riscv files
4. In the main menu select option 3 to build the cycle accurate simulator. This will take you to a sub menu.
5. In the sub menu select option 1 to build the included simulator (Verilator). Enter "B" to go back after building has completed
6. In the main menu select option 6 to choose your emulator/simulator. This will take you to a sub menu
7. In the sub menu select option 1 to run the included stress tests for the cycle accurate simulator.
8. In the sub menu select option 7 to run a test hello world program on the lower accuracy simulator.

If all goes well, you should have a fully functioning RISCV setup.

### Continued Use

After going through the steps above you no longer need to do steps 1 through 3. 
From this point on anytime change is made to the hardware, first press E to set temporary enviornment variables then simply run steps 4 through 8 to ensure proper functionality

### Custom C Programs

If you would like to run custom C programs do the following:
1. In the main menu select option 5.
2. In the sub menu select option 8.
3. Provide the path to your C program
4. Provide the name of your C Program

Your program should compile and run in the low accuracy simulator

### Building and Running Linux
After going through the initial setup you can configure and setup linux to run on spike (the low accuracy simulator) by doing the following:
1. Run the riscv_tool script
2. Press E to set temporary enviornment variables
3. Press 5 to go to the linux setup menu
4. Choose 1 to build the cross compiler
5. Choose 3 to download a linux kernel of your choice. This will download the riscv-linux repo and then download the official linux kernel revision to patch the repo with. It is important to note that there might be some incompatability based on the riscv linux kernel repo and the patch the reivision that used. If you run into build issues in later steps try a newer revision. At the time of writing 4.9.99 is known to work with ease.
6. Choose 4 to set default settings for a basic riscv linux kernel. If you need more features or less choose 5.
7. Choose 6 to build the kernel
8. Choose 7 to download tools and utilities to complement your newly built linux kernel.
9. Choose 8 to configure which tools and utilties to include in your linux installation. These include things like the shell, command line utilities etc.
8. By choosing 8 you will be presented with a menu. Choose the following for a basic practical linux installation
  * Set Busybox Settings ---> Build Options ---> Build BusyBox as a static binary (no shared libs)
  * Fill Cross Compiler prefix() with riscv64-unknown-linux-gnu- at Busybox Settings ---> Build Options --->Cross Compiler      
    prefix() (include - after gnu)
  * Set Busybox Settings ---> Include busybox applet ---> Support --install [-s] to install applet links at runtime
  * Set Init Utilities ---> init
  * Set Init Utilities ---> Support reading an inittab file
  * Set Linux System Utilities ---> mount
  * Set Shells ---> ash
  * Set Shells ---> ash ---> Job Control
 9. Save and exit the menu then choose 9 to build the utilities
 10. Choose 10 to create the disk to boot from
 11. Go back to the main menu then choose 6 to choose your emulator
 12. Choose 9 to run linux in the low accuracy simulator (spike)
 
Congrats now you have your own custom version of linux running. This installation is very barebones. You can add more usability to it through additional busy box options.

### Building and Running QEMU
After going through the initial setup you can configure and setup linux to run on QEMU (the low accuracy simulator) by doing the following:
1. Run the riscv_tool script
2. Choose E to set temporary enviornment variables
3. Choose 3 to go to the build simulator menu
4. Choose 4 to build QEMU
5. Press B to go back to the main menu
6. Choose 5 to go to the linux setup menu
7. Choose 2 to download a prebuilt Fedora image
8. Choose B to go back to the main menu
9. Choose 6 to go to the emulation menu
10. Choose 10 to boot into Fedora using QEMU
11. Username is root, password is riscv

Congrats now you have QEMU running Fedora ont he riscv architecture. Some functionality is a bit limited, but at the time of writing it is close to a full system. Try compiling and using the included raytracer program! (./raytracer <scenefile>). You can mount the fedora image and see its contents using `sudo losetup -Pf <path to riscv tool scripts>/riscv-fedora/<fedora raw disk image file>`


---

## Scriptless Usage
### Scriptless Setup

The following information is copied,modifiedm,reorganized,and/or merged from the riscv and freechip repositories

#### Initial Setup
First we must get the necessary files. 

1) Go to a new empty directory, add it to your enviornment variables and clone the repository.

`$ export TOP=$(pwd)`

`$ git clone https://github.com/ucb-bar/rocket-chip.git`

2) Create a new enviornment variable for the project building tools to locate main project folder

`$ cd rocket-chip`

`$ export ROCKETCHIP=$(pwd)`

3) Making sure everything is up to date

`$ git submodule update --init`

`$ cd riscv-tools`

`$ git submodule update --init --recursive`

4) Create a new enviornment variable for the project building tools to locate riscv-toolchain. This is the path to the riscv-tools folder

`export RISCV=<path to riscv-tools directory>`

`export PATH=$PATH:$RISCV/bin`

#### Building And Testing The Toolchain
5) Go to the riscv-tools folder

`cd $RISCV`

6) Set the number of logical cores to compile on

`export MAKEFLAGS="$MAKEFLAGS -jN" # Assuming you have N cores on your host system`

7)Build the 64bit toolchain

`$ ./build.sh`

You can also specifcy the compiler version to use as follows

`CC=gcc-4.8 CXX=g++-4.8 ./build.sh`

8)Now go to your top folder and create the a sample program

`$ cd $TOP`

`$ echo -e '#include <stdio.h>\n int main(void) { printf("Hello world!\\n"); return 0; }' > hello.c`

9)Build the program for the low accuracy simulator

`$ riscv64-unknown-elf-gcc -o hello hello.c`

Make sure you have exported PATH=$PATH:$RISCV/bin otherwise the compiler will not be found

10)Create a new enviornment variable for the proxy kernel to run the program.

 `export PK=$RISCV/riscv64-unknown-elf/bin/pk`
 
11) Run the test program. If everything is working you should see "Hello world!"

`spike $PK hello`

#### Building And Testing Verilog Simulators/Emulators
12) Your next step is to get the Verilator working. Assuming you have N cores on your host system the following commands will build and run all tests for the simulator. This might take some time:

`$ cd $ROCKETCHIP/emulator`

`$ make -jN run`

13) You will also want to generate verilog for VLSI tools if you have them. To do so do the following:

`$ cd $ROCKETCHIP/vsim`

`$ make verilog`

The output files are located at

`$ cd $ROCKETCHIP/vsim/generated-src`

#### Configuring And Building Linux For RISCV From Scratch
Your next step is to get linux running on Spike.
##### Build The Kernel
14) Go to the riscv-tools/riscv-gnu-toolchain folder

`cd $RISCV/riscv-gnu-toolchain`

15) Configure the riscv tool chain for linux then make it

`./configure --prefix=$RISCV`

`make linux`

16) Download a linux kernel into the root of the project (preferably version 4.x+ to align with the most recent riscv-linux repo)

`cd $TOP`

`git clone https://github.com/riscv/riscv-linux.git linux-4.9.99`

17) Patch the kernel revision you downloaded

`curl -L https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.9.99.tar.xz | tar -xJkf -`

18) Configure the linux kernel with default or custom settings.

`cd linux-4.9.99`

`make ARCH=riscv defconfig`

`make ARCH=riscv menuconfig`

19) Build the kernel

`make $MAKEFLAGS ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-gnu-`

##### Build Linux Utilties

20) Download linux utilities (Busybox)

`cd $TOP`

`curl -L http://busybox.net/downloads/busybox-1.29.2.tar.bz2 > busybox-1.29.2.tar.bz2`

`tar xvjf busybox-1.29.2.tar.bz2`

21) Clear default configuration then configure Busybox features to be used in our linux installation

`cd busybox-1.29.2`

`make allnoconfig`

`make menuconfig`

22) You will be presented with a menu. Choose the following for a basic practical linux installation then save and exit

  * Set Busybox Settings ---> Build Options ---> Build BusyBox as a static binary (no shared libs)
  * Fill Cross Compiler prefix() with riscv64-unknown-linux-gnu- at Busybox Settings ---> Build Options --->Cross Compiler      
    prefix() (include - after gnu)
  * Set Busybox Settings ---> Include busybox applet ---> Support --install [-s] to install applet links at runtime
  * Set Init Utilities ---> init
  * Set Init Utilities ---> Support reading an inittab file
  * Set Linux System Utilities ---> mount
  * Set Shells ---> ash
  * Set Shells ---> ash ---> Job Control
  
23) Build the utilities

`make $MAKEFLAGS`

##### Create Disk Image

24) Now we will setup the directories needed for our linux installation

`cd $TOP/linux-4.9.99`

`mkdir root`

`cd root`

`mkdir -p bin etc dev lib proc sbin sys tmp usr usr/bin usr/lib usr/sbin`

25) Install busybox utilties

`cp $TOP/busybox-1.29.2/busybox bin`

26) Get a basic initialization script for our linux installation

`curl -L http://riscv.org/install-guides/linux-inittab > etc/inittab`

26) Finalaize busybox installation by linking it to the necessary directories

`ln -s ../bin/busybox sbin/init`

`ln -s sbin/init init`

27) Setup console

`sudo mknod dev/console c 5 1`

28) Create linux disk

`find . | cpio --quiet -o -H newc > $TOP/linux-4.9.99/rootfs.cpio`

29) Configure linux to use our newly created disk. This will bring a menu.

`make ARCH=riscv menuconfig`

This will bring up a menu. Choose General Setup and select  "Initial RAM filesystem and RAM disk" or something similar. Then choose "initramfs source file" and type in rootfs.cpio. Now you can save and exit

30) Now you must rebuild the linux kernel

`cd $TOP/linux-4.9.99`

`make $MAKEFLAGS ARCH=riscv vmlinux CROSS_COMPILE=riscv64-unknown-linux-gnu-`

31) You must also rebuild the boot loader for the kernel

`cd $RISCV/riscv-pk/build`

`rm -rf *`

`../configure --prefix=$RISCV --host=riscv64-unknown-linux-gnu --with-payload=$TOP/linux-4.9.99/vmlinux`

`make`

`sudo make install`

##### Running Linux

32) Now you can boot linux through spike

`spike bbl $TOP/linux-4.9.99/vmlinux`

#### Setting Up QEMU

33) Go to the riscv toolchain folder

`cd $RISCV/riscv-gnu-toolchain`

33) Get the latest version of qemu and then go into the repo

`git clone https://github.com/qemu/qemu.git`

`cd qemu`

34) Configure it to be able to run in user only mode and full system mode

`./configure --target-list=riscv64-softmmu,riscv64-linux-user`

35) Build and install qemu

`make -j$MAKEFLAGS`

`sudo make install`

36) Download a prebuilt fedora image for riscv-qemu

`cd $TOP`

`mkdir riscv-fedora`

`cd riscv-fedora`

`wget http://fedora-riscv.tranquillity.se/kojifiles/work/tasks/4544/104544/Fedora-Developer-Rawhide-20180908.n.0-sda.raw.xz`

37) Get a riscv bootloader to boot to the kernel

`wget https://fedorapeople.org/groups/risc-v/disk-images/bbl`

38) Extract the fedora image

`unxz Fedora-Developer-Rawhide-20180908.n.0-sda.raw.xz`

39) Run qemu with these parameters to get a virtual riscv system

`qemu-system-riscv64 \
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
-netdev user,id=usernet,hostfwd=tcp::10000-:22`

#### Writing Assembly Programs

Before writing an assembly program review the following resources on riscv calling conventions, instructions etc.
https://rv8.io/asm
https://www.imperialviolet.org/2016/12/31/riscv.html
https://github.com/riscv/riscv-elf-psabi-doc/blob/master/riscv-elf.md

Writing a riscv assembly program is similar to writing an ARM assembly program (or any other assembly program for that mattter). You must specify sections for a linker, set alignments, and set global directives. An example is shown below:

`	.section	.text`

`	.align 1`

`	.globl main`

`main:`

Check the first linked resource for more directive options.

After this initial setup you can start writing assembly programs. There are a couple different routes to take:
### 1) A baremetal program
A baremetal program assumes zero external code. No libraries, no kernel, etc. This makes doing tasks like I/O troublesome, but whatever the processor does is up to you.

//NEED TO MAKE BAREMETAL EASIER TO DO

### 2) A kernel compliant program
This route assumes your assembly application is started by a kernel. This means you have to setup the stack and frame pointer of your application so that the application can exit/trap gracefully, and the kernel can continue operating properly. The code below shows the first few lines of this type of program and the last few lines.

`main: `

 ` addi sp,sp,-16	#prepare space for callers frame pointer, and return address; riscv wants 16byte aligned stack`
 
`	sd   ra,8(sp)	#store return address`

`	sd   s0,0(sp)   #save pointer to old stack frame, serves as a good base for new stack`

`	addi s0,sp,16   #setup frame pointer for current stack, points to "top" of stack`
  
 ` #Do this at the end of your program`
 
  `li	a5,0			#setup return args in a0`
  
`	mv	a0,a5`

`	ld	ra,8(sp)		#reload return address and old frame pointer`

`	ld	s0,0(sp)`

`	addi	sp,sp,16		#roll back stack pointer`

`	jr	ra			#go back to kernel (i think risc-v pk uses _start and then calls exit`
  
By using a kernel (like the riscv proxy kernel) you can do basic I/O. In order to do so you must follow call procedure conventions which can be inferred from the 3rd link listed above under "Integer register conventions". After setting up for a function call you can use the `call` pseudo instruction to run that function. There is also the `ecall` instruction that is used when calling kernel functions. Using 'ecall' requires you to know the convention of the kernel you are using.

The riscv proxy kernel traps to a function defined as `long do_syscall(long a0, long a1, long a2, long a3, long a4, long a5, unsigned long n)` whenever `ecall` is executed. The parameters of do_syscall are assumed to be stored in registers a0-a7. Each syscall has an associated function id. sys_write for example is 64. To find the argument format, other syscall id's, file descriptors, etc for the riscv proxy kernel please check both the following links:
https://github.com/riscv/riscv-pk/blob/master/pk/syscall.h
https://github.com/riscv/riscv-pk/blob/master/pk/syscall.c

To build and run this code you must run the following command (where program is the name of your source):
`riscv64-unknown-elf-gcc program.S -o program`

You can then run the code through the proxy kernel as follows:
`spike pk program`

You can also get gdb debugging support by adding `-g` to the gcc command, and dynamic instruction count with the `-taddi` option after spike.

#### Debugging Your Assembly Program

There are a number of ways to debug your program.
### Debugging Using GDB
Using GDB alllows you to go through your assembly program step by step. Due to the infancy of riscv tools there is some peculiar behavior that we  must work around before using gdb. Assuming your assembly program is using a kernel we must add the following lines of code after setting up the stack frame inorder to halt the program. This will forcefully halt gdb's execution of our program so that we can can setup breakpoints and view register contents. It seems GDB does not have a sense of the system under test until the program is running which keeps us from setting breakpoints and such. S,o we must halt the program before gdb finishes execution. Now that the program has started running GDB understands the system and allows us to use its other features.

`#compensate for gdb's inability to load registers before hand, do this after setting up stack frame`

`	lui	a0,%hi(print_t)		#lets get input using scanf this time`

`	addi	a0,a0,%lo(print_t)`

`	call	scanf`
  
 ` #put this at the bottom of your program`
 
  `.section .rodata #readonly data section`
  
`	.align 3	#RISCV64 likes 8 byte alignment for data`

 ` print_t:`
 
  `  .string "%s"`
    
After compiling your program with this code and the `-g` flag run gdb as follows:
`riscv64-unknown-elf-gdb -tui program`

This will open up a UI for gdb. From the gdb command line set gdb to load and debug riscv programs as follows:
`target sim`

`load`

Then setup the gui to show register and source at the same time. To do this type:
`layout split`
Then iterate until you see a screen that shows but assembly source and a register contents window (that most likely says registers unavailable). To this type:
`layout n`

At this point you are ready to debug your application. Run your program with `run` and it should halt while executing a scanf function call. Stop GDB's execution by pressing ctrl + c. GDB should be displaying register values now. We can return to our program by typing `ni` into gdb's command line to parse the next instruction. Do this until you have returned to your program. From this point on all of gdb's features should work properly. As you use `ni` or `si` to go through your program you should see register values change!

### Debugging Using Spike
It is also possible to debug your program using spike. By running spike with the `-d` flag you can step through your programs instruction by instruction and get a number of debug information. Typing help should show you the various features available to you. Keep in mind that when running spike with debug it will start executing the very first line of the proxy kernel if you are using it. To avoid this you can get spike to run quietly until it hits the address of the first instruction of your program. To get this address run this command `riscv64-unknown-elf-objdump -S program &> dump` before debugging with spike. This will write to a file named dump. By reading through this file you can find the first address of your assembly program (amongst various other libraries that are included with your application). You can then use this address within spike while in debug mode (use help to see what instructions you can use it with)


---

## NOTE/TODO
There are still a number of unexplored features to be included. These include basic parameterazation of the hardware within the scripts. A seperate dedicated compilation page for more options. Custom C and C++ code on the cycle accurate emulator. A benchmarking menu using parsec. More to be decided
