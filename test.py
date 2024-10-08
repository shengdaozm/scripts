import os
import subprocess
import sys
import get_test_op
import csv

GREEN = '\033[92m'
ENDC = '\033[0m'

def todo():
    return None

# do all the tests,including benchmark and expr_benchmark etc.
def benchmark():
    print(f"{GREEN}=============start benchmark================{ENDC}")
    os.system("sh ./benchmark.sh")
    print(f"{GREEN}=============finish benchmark================{ENDC}")
    

def expr_benchmark():
    print(f"{GREEN}=============start expr_benchmark================{ENDC}")
    os.system("sh ./expr_benchmark.sh")
    print(f"{GREEN}=============finish expr_benchmark================{ENDC}")

def test():
    op,test_names=get_test_op.job()
    test_content = []
    for op_name in op:
        print(f"{GREEN}=============Executing test case: {op_name}================{ENDC}")
        command_without_perf = f"./run_test.out {op_name} >test.log"
        command_without_perf2 = f"echo '&&' >>test.log"
        command_with_perf = f"./perf.sh './run_test.out {op_name}'"
        #os.system(command_with_perf)
        os.system(command_without_perf)
        """
        try:
            test_content.append(subprocess.run(command_without_perf,capture_output=True, text=True, check=True).stdout)
        except subprocess.CalledProcessError as e:
            print(f"{GREEN}Test case {op_name} failed!{ENDC}")
        """
        
    # 把所有test_content写入csv文件
    """
    with open("test.csv", "w",encoding='utf-8',newline='') as f:
        writer = csv.writer(f)
        for i in range(len(test_content)):
            writer.writerow(test_content[i])
    """

    print(f"{GREEN}All test cases have been executed!{ENDC}")


if __name__ == '__main__':
    # if there is a parameter "dc", then run dc.sh
    if len(sys.argv) > 1 and sys.argv[1] == "dc":
        os.system("sh ./dc.sh")
        exit(0)

    #  move the test file to the current directory
    os.system("sh ./move_testfile.sh")
    benchmark()
    expr_benchmark()
    test()