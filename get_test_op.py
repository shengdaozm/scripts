import os
import re

# 该文件按顺序返回所有地测试案例，包括已经去掉的部分

"""
test_cpp_files: 带有cpp名字的绝对路径的文件和去掉cpp后缀的文件名(表格测试使用)
"""
def find_test_cpp_files(directory):
    """查找目录下所有名称中包含 'Test' 的文件"""
    test_cpp_files = []
    test_cpp_names = []
    for root, _, files in os.walk(directory):
        for file in files:
            if 'Test' in file:
                test_cpp_files.append(os.path.join(root, file))
                test_cpp_names.append(file.replace('.cpp', ''))# 文件的测试名字
    return test_cpp_files ,test_cpp_names


"""
find_test_contents: 找到每个测试案例对应的op的名称
"""
def find_test_contents(file_path):
    test_names = []
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
        matches = re.findall(r'MNNTestSuiteRegister\([^,]+,\s*"([^"]+)"\s*\);', content, re.DOTALL)
        test_names.extend(matches)
    return test_names


def get_op_name(test_ops):
    delete_ops=[
        "backend/cpu/compute/blstm_computer_nc4hw4",
        "backend/cpu/compute/blstm_computer_normal",
        "backend/cpu/compute/blstm_computer_unidirection", 
        #"speed/ConvInt8/depthwise", # arm失效，rv通过
        #"op/ConvInt8/im2col_gemm", # arm失效，rv通过
        #"op/ConvInt8/im2col_spmm", # 支持支arm32/64 ，rv下直接跳过
        #"op/ConvInt8/winograd", #arm通过，rv下直接跳过
        #"op/DeconvolutionInt8",# arm失效，rv通过
        #"speed/ConvInt8/winograd", # arm失效，rv通过
        "model/transformer" ,
        "plugin" ,# plugin只在release版本支持，构建动态库无法使用
        "model/model_test"
        ]
    # 在test_ops中删除位于delete_ops中的op
    for op in delete_ops:
        if op in test_ops:
            test_ops.remove(op)
    
    return test_ops

"""
对外提供的接口，执行job函数，即可得到需要进行测试的op和对应的测试表格中的test_name
op:命令行执行需要的名字
test_name:测试表格对应的名字
已经完成了排序，两者一一对应
共331个op
"""
def job():
    op=[]
    test2file={} #{op:testfile_name}
    directory = '../mnn/test/'  # 目标目录
    test_cpp_files,test_cppfile_names = find_test_cpp_files(directory) # 绝对路径的test.cpp文件

    
    for i in range(len(test_cpp_files)):
        contents = find_test_contents(test_cpp_files[i])
        if contents:
            for tmp in contents:
                op.append(tmp)
                test2file[tmp]=test_cppfile_names[i]
    op=sorted(op)
    op=get_op_name(op) #删除部分的op
    test_name=[] #测试名称中的名称
    for op_name in op:
        pre_test_name=test2file[op_name]
        """
        处理同名部分的特判,op不要处理，test_name由于命名规则，需要操作
            model/mobilenet/1/caffe和model/mobilenet/2/caffe
            op/ConvInt8/winograd和speed/ConvInt8/winograd
        """
        # op_name分割/，获得最后一个/的内容，与pre_test_name拼接
        tmp=pre_test_name+"_"+op_name.split("/")[-1]
        if op_name=="model/mobilenet/1/caffe":
            tmp += "_1"
        elif op_name=="model/mobilenet/2/caffe":
            tmp += "_2"
        elif op_name=="op/ConvInt8/winograd":
            tmp+= "_op"
        elif op_name=="speed/ConvInt8/winograd":
            tmp +="_speed"
        
        test_name.append(tmp)

    return op,test_name