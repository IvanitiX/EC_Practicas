#!/bin/bash

for i in $(seq 1 9); do
rm sumaCarry
gcc -x assembler-with-cpp -D TEST=$i -no-pie sumaregacarreo.s -o sumaCarry
echo -n "T#$i "; ./sumaCarry
done
