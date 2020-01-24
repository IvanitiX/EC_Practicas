for i in 0 g 1 2; do
    printf "__OPTIM%1c__%48s\n" $i "" | tr " " "="
    rm popcount
    gcc popcounttest.c -o popcounttest -O$i -D TEST=0
    for j in $(seq 0 10); do
        echo $j; ./popcounttest
    done | pr -11 -l 22 -w 80
done