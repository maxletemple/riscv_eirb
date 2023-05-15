riskV: riskV.o sequenceur.o decoblock.o ALU.o
	gcc riskV.o sequenceur.o decoblock.o ALU.o -o riskV

riskV.o: riskV.c sequenceur.h decoblock.h ALU.h
	gcc -c -Wall -std=c99 riskV.c

sequenceur.o: sequenceur.c sequenceur.h
	gcc -c -Wall -std=c99 sequenceur.c

decoblock.o: decoblock.c decoblock.h
	gcc -c -Wall -std=c99 decoblock.c

ALU.o: ALU.c ALU.h
	gcc -c -Wall -std=c99 ALU.c
clean:
	rm *.o riskV

