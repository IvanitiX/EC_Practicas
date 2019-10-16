#!/bin/bash

for i in $(seq 1 19); do
rm sumaES
gcc -x assembler-with-cpp -D TEST=$i -no-pie sumaenterosextsigno.s -o sumaES
echo -n "T#$i "; ./sumaES
done
