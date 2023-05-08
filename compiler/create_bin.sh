#arg 1 to n-2: sources files for gcc
#arg n-1     : executable output
#arg n       : binary output
n=$#


PATH_TO_COMPILER=/opt/riscv/bin

$PATH_TO_COMPILER/riscv32-unknown-elf-gcc -o0 -ffreestanding -Wl,-T,memory_map.ld -nostartfiles -nostdlib -nodefaultlibs -o ${@:$(( $#-1 )):1} ${@:1:$((n-2))}
$PATH_TO_COMPILER/riscv32-unknown-elf-objcopy --change-section-lma .rodata=0x400 --change-section-lma .text=0x000 -O binary ${@:$(( $#-1 )):1} ${@: -1}

filesize=2048
currentsize=$(wc -c < ${@: -1})
zerocount=$((filesize-currentsize))

truncate -s +$zerocount ${@: -1}
