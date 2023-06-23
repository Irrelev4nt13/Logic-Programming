#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char *argv[])
{
   int i, start, dur, nact = 10, maxstart = 20, maxdur = 5, seed, sdur = 0;
   seed = (unsigned int) time(NULL);
   if (argc > 1)
      nact = atoi(argv[1]);
   if (argc > 2)
      maxstart = atoi(argv[2]);
   if (argc > 3)
      maxdur = atoi(argv[3]);
   if (argc > 4)
      seed = (unsigned int) atoi(argv[4]);
   srand(seed);
   for (i = 1 ; i <= nact ; i++) {
      start =  rand() % (maxstart + 1);
      dur = (rand() % maxdur) + 1;
      sdur += dur;
      printf("activity(a%03d, act(%d,%d)).\n", i, start, start + dur);
   }
// printf("Total duration: %d\n", sdur);
   return 0;
}
