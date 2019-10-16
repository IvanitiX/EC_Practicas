#!/bin/bash

for i in $(seq 1 9); do
rm SumaCero
gcc -x assembler-with-cpp -D TEST=$i -no-pie sumaextensioncero.s -o SumaCero
echo -n "T#$i "; ./SumaCero
done
