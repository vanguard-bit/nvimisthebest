#include <stdio.h>



typedef unsigned int uint;



void print_binary(uint num) {

  for (int i = sizeof(uint) * 8 - 1; i >= 0; i--) {

    printf("%d", (num >> i) & 1);

  }

}



int main() {

  uint num = 1223212320;

  print_binary(num);

  return 0;

}

