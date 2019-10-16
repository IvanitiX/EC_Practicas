#!/bin/bash

for i in $(seq 1 19); do
rm media32
gcc -x assembler-with-cpp -D TEST=$i -no-pie media_x86_32.s -o media32
echo -n "T#$i "; ./media32
done
