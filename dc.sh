#!/bin/bash
# 下载源代码
# 当前目录在scripts下
# download && compile
# source code version 2.9.3
cd ..
wget https://github.com/alibaba/MNN/archive/refs/tags/2.9.3.tar.gz
tar -zxvf 2.9.3.tar.gz && mv MNN-2.9.3 mnn && rm 2.9.3.tar.gz

cd mnn && mkdir build && cd build

cd ..
./schema/generate.sh
cd build

# patch，修正源代码和测试用例代码
# arm下执行

#patch -p0 ../mnn/source/backend/cpu/CPURuntime.cpp   <./patch/arm_CPURuntime.patch
#patch -p0 ../mnn/test/core/BackendTest.cpp   < ./patch/BackendTest.patch

# 编译命令调整
cmake .. -DMNN_BUILD_TRAIN=ON -DMNN_BUILD_BENCHMARK=ON -DMNN_BUILD_TEST=ON -DMNN_USE_OPENCV=OFF -DMNN_BUILD_OPENCV=OFF -DMNN_CUDA=OFF -DMNN_ONEDNN=OFF -DMNN_OPENCL=OFF -DMNN_OPENGL=OFF -DMNN_VULKAN=OFF -DMNN_ARM82=OFF -DMNN_TENSORRT=OFF -DMNN_OPENMP=OFF -DMNN_COREML=OFF -DMNN_NNAPI=OFF -DMNN_SUPPORT_BF16=OFF -DMNN_BUILD_MINI=OFF -DMNN_METAL=OFF -DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} -Wall -O0 -g -fno-omit-frame-pointer" -DCMAKE_C_FLAGS="${CMAKE_C_FLAGS} -Wall -O0 -g -fno-omit-frame-pointer"

make -j20 # 根据实际情况进行调整,默认是j8

cmake .. -DMNN_BUILD_CONVERTER=ON && make -j8

cd ../tools/script/
# 为了避免网络问题，直接多执行几次即可,此处依赖上面编译的转换工具
./get_model.sh
./get_model.sh
./get_model.sh