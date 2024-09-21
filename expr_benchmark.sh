#!/bin/bash
# expr_benchmark test no perf
./benchmarkExprModels.out ResNet_100_18 10 0 4 >> expr_benchmark.txt
printf "&&" >> expr_benchmark.txt
./benchmarkExprModels.out GoogLeNet_100 10 0 4 >> expr_benchmark.txt
printf "&&" >> expr_benchmark.txt
./benchmarkExprModels.out SqueezeNet_100 10 0 4 >> expr_benchmark.txt
printf "&&" >> expr_benchmark.txt
./benchmarkExprModels.out ShuffleNet_100_4 10 0 4 >> expr_benchmark.txt
printf "&&" >> expr_benchmark.txt

# expr_benchmark test with perf
./perf.sh "./benchmarkExprModels.out ResNet_100_18 10 0 4"
./perf.sh "./benchmarkExprModels.out GoogLeNet_100 10 0 4"
./perf.sh "./benchmarkExprModels.out SqueezeNet_100 10 0 4" 
./perf.sh "./benchmarkExprModels.out ShuffleNet_100_4 10 0 4"

echo "=================================" >> perf.txt
