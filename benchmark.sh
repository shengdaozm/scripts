# benchmark.txt
mnn_models=("MobileNetV2_224.mnn" "SqueezeNetV1.0.mnn" "inception-v3.mnn" "mobilenet-v1-1.0.mnn" "mobilenetV3.mnn" "nasnet.mnn" "resnet-v2-50.mnn" "squeezenetv1.1.mnn")

mkdir test_benchmark
touch test_benchmark/loopkeep
for model in ${mnn_models[@]}
do
    rm test_benchmark/*
    cp models/$model test_benchmark/

    # no perf
    ./benchmark.out test_benchmark/ 10 0 0 >>benchmark.txt
    printf "&&" >> benchmark.txt
    
    #perf
    ./perf.sh "./benchmark.out test_benchmark/ 10 0 0"
done
echo "=================================" >> perf.txt