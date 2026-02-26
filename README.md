# terminalOS
A boot sector OS in the terminal that can fit in a single floppy disk.

![Image](https://raw.githubusercontent.com/windowsuser688/terminalOS/refs/heads/main/preview_image.PNG)

# How to assemble
- First, download the zip file and extract it, then get the terminalOS.asm file and paste it where you want.
- Next, download the NASM assembler from [here](https://www.nasm.us/) and download the installer.
- Then, set the NASM Install to the system PATH if you are on Windows. If you are on Linux/macOS, it might have already have the commands you needed during compiling.
- After installing NASM, go to your terminal and type "nasm -f bin terminalOS.asm -o terminalOS.bin".
- Then, if you are on macOS/Linux, you might have the "dd" command. If you are on Windows, follow this next step.
- Download dd for Windows [here](http://www.chrysocome.net/dd) and paste it in a hidden location, then set it to the PC's PATH.
- Then, go to your terminal and type this command: "dd if=/dev/zero of=terminalOS.img bs=512 count=2880".
- And then, type: "dd if=terminalOS.bin of=terminalOS.img bs=512 count=1 conv=notrunc".
- You're done assembling and ready to boot into it!
# How to boot into created image file
- First, download QEMU and select your OS. Download it [here.](https://www.qemu.org/download/)
- Then, for Windows users, set the QEMU install path to the system's PATH.
- After that, go into your terminal, navigate to your assembled image file location and type "qemu-system-i386 -fda terminalOS.img".
- Your done and booting into the OS!
# What are the commands?
- HELP (Shows all available commands)
- ECHO (Echoes text)
- CLS (Clears the terminal)
- CRASH (Crashes the OS, however i don't know if it actually crashes the OS)
- SHUTDOWN (Shuts down the OS.)
- REBOOT (Reboots the OS.)
# Q&A
- Q: Is it open source?
- A: Hell yeah! We provide the assembly file and you can use it to tweak your perferences.
- Q: Is it based off the linux kernel?
- A: No, it is not based off the linux kernel. It was built all from scratch using real x86 assembly.
- Q: Will it have more commands in the future?
- A: Well, we will provide more commands, however, a boot sector OS is limited to 512 bytes only, otherwise it won't boot if it's past this limit.
- Q: What is it inspired from?
- A: It is inspired by bootOS, another project way before this was released.
- Q: Why can't i switch to lowercase?
- A: Due to assembly's strict enforcement codes, assembly forces the command to only be used as uppercase, so we implemented a feature that when you type something, it forces it to go uppercase. This will be changed in a update.
- Q: Is it recommended to install it on my main PC?
- A: No. It is not recommended to install it on your main PC. However it is possible, but you will have a high risk of losing all your saved work from your previous OS.
