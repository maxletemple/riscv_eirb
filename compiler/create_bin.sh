#arg 1 to n-2: sources files for gcc
#arg n-1     : executable output
#arg n       : binary output

n=$#

PATH_TO_COMPILER=/opt/riscv/bin

# -ffreestanding -nostartfiles -nostdlib -nodefaultlibs précise que l'on travaille en baremetal, et donc aucune fonction système ne peut être utilisée
# -o0 déactive toutes les optimisations
# -ffunction-sections -Wl,-gc-sections permet de supprimer les fonctions de lib.h qui ne sont pas utilisées
$PATH_TO_COMPILER/riscv32-unknown-elf-gcc -o0 -ffunction-sections -Wl,-gc-sections -ffreestanding -Wl,-T,memory_map.ld -nostartfiles -nostdlib -nodefaultlibs -o ${@:$(( $#-1 )):1} ${@:1:$((n-2))}

# --change-section-lma .rodata=0x400 --change-section-lma .text=0x000 précisent la taille des mémoires de donnée et de programme
$PATH_TO_COMPILER/riscv32-unknown-elf-objcopy --change-section-lma .rodata=0x400 --change-section-lma .text=0x000 -O binary ${@:$(( $#-1 )):1} ${@: -1}

# remplissage du ficher avec des 0
filesize=2048
currentsize=$(wc -c < ${@: -1})
zerocount=$((filesize-currentsize))

truncate -s +$zerocount ${@: -1}
