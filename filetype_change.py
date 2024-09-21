import csv
import sys

GREEN = '\033[92m'
ENDC = '\033[0m'

# 定义函数，将 txt 文件转换为 csv 文件
def txt_to_csv(txt_file_path, csv_file_path):
    with open(txt_file_path, 'r', encoding='utf-8') as txt_file:
        # 读取整个文件内容
        content = txt_file.read()
        
        # 使用 '&&' 分割文件内容
        blocks = content.split('&&')

        # 打开 CSV 文件进行写入
        with open(csv_file_path, 'w', newline='', encoding='utf-8') as csv_file:
            writer = csv.writer(csv_file)
            # 遍历每个数据块并写入 CSV 文件
            for block in blocks:
                # 移除前后空白符，避免空行
                block = block.strip()
                if block:
                    # 将每个块写入 CSV 文件，作为一行
                    writer.writerow([block])


txtfile = sys.argv[1]  
csvfile = sys.argv[2]

txt_to_csv(txtfile, csvfile)
print(f"{GREEN}results have been saved to csv file!{ENDC}")