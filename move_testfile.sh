#!/bin/bash
# directory:scripts/

### expr_benchmark
#移动expr_model
cp ../mnn/build/benchmarkExprModels.out .

### benchamrk
#移动benchmark.out
cp ../mnn/build/benchmark.out .
#移动benchmark测试用model
cp -r ../mnn/benchmark/models .

### 移动run_test.out
cp ../mnn/build/run_test.out .