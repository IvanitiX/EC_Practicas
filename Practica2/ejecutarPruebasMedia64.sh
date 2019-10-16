#!/bin/bash

for i in $(seq 1 19); do
rm media64
gcc -x assembler-with-cpp -D TEST=$i -no-pie media_x86_64.s -o media64
echo -n "T#$i "; ./media64
done
