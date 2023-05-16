riscV: riscV.o sequenceur.o decoblock.o ALU.o
	gcc riscV.o sequenceur.o decoblock.o ALU.o -o riscV

riscV.o: riscV.c sequenceur.h decoblock.h ALU.h
	gcc -c -Wall -std=c99 riscV.c

sequenceur.o: sequenceur.c sequenceur.h
	gcc -c -Wall -std=c99 sequenceur.c

decoblock.o: decoblock.c decoblock.h
	gcc -c -Wall -std=c99 decoblock.c

ALU.o: ALU.c ALU.h
	gcc -c -Wall -std=c99 ALU.c
clean:
	rm *.o riscV

