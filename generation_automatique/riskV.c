#include "sequenceur.h"
#include "decoblock.h"
#include "ALU.h"
int main(int argc, char *argv[])
{
  sequenceur(argv[1]);
  decoblock(argv[1]);
  ALU(argv[1]);
}
