# import pandas as pd
# import psycopg2

# # Kết nối đến cơ sở dữ liệu
# conn = psycopg2.connect(
#     dbname='Fitness_App',  # Thay thế bằng tên cơ sở dữ liệu của bạn
#     user='postgres',     # Thay thế bằng tên người dùng của bạn
#     password=12345,  # Thay thế bằng mật khẩu của bạn
#     host='localhost',         # Thay thế nếu cần
#     port='5432'              # Thay thế nếu cần
# )

# # Tạo DataFrame để lưu thông tin
# tables_info = pd.DataFrame(columns=['Table Name', 'Primary Key', 'Foreign Keys', 'Columns'])

# # Truy vấn danh sách tất cả các bảng trong schema public
# tables_query = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';"
# tables = pd.read_sql_query(tables_query, conn)

# # Lặp qua từng bảng để lấy thông tin
# for table in tables['table_name']:
#     # Lấy tên cột
#     columns_query = f"""
#     SELECT column_name 
#     FROM information_schema.columns 
#     WHERE table_name = '{table}';
#     """
#     columns = pd.read_sql_query(columns_query, conn)['column_name'].tolist()

#     # Lấy khóa chính
#     primary_key_query = f"""
#     SELECT column_name 
#     FROM information_schema.key_column_usage 
#     WHERE table_name = '{table}' AND constraint_name LIKE '%pkey';
#     """
#     primary_key = pd.read_sql_query(primary_key_query, conn)['column_name'].tolist()

#     # Lấy khóa ngoại
#     foreign_keys_query = f"""
#     SELECT kcu.column_name, ccu.table_name AS foreign_table, ccu.column_name AS foreign_column
#     FROM information_schema.table_constraints AS tc 
#     JOIN information_schema.key_column_usage AS kcu
#       ON tc.constraint_name = kcu.constraint_name
#     JOIN information_schema.constraint_column_usage AS ccu
#       ON ccu.constraint_name = tc.constraint_name
#     WHERE constraint_type = 'FOREIGN KEY' AND kcu.table_name = '{table}';
#     """
#     foreign_keys = pd.read_sql_query(foreign_keys_query, conn)

#     foreign_keys_list = []
#     for index, row in foreign_keys.iterrows():
#         foreign_keys_list.append(f"{row['column_name']} -> {row['foreign_table']}({row['foreign_column']})")

#     # Lưu thông tin vào DataFrame
#     new_row = pd.DataFrame({
#         'Table Name': [table],
#         'Primary Key': [', '.join(primary_key)],
#         'Foreign Keys': ['; '.join(foreign_keys_list)],
#         'Columns': [', '.join(columns)]
#     })
    
#     tables_info = pd.concat([tables_info, new_row], ignore_index=True)

# # Xuất thông tin ra file Excel
# tables_info.to_excel('E:/n4k1/chuyên đề 3/table_info.xlsx', index=False)

# # Đóng kết nối
# conn.close()
import os

def get_folder_structure(dir_path, output_file="folder_structure1.txt"):
    with open(output_file, "w") as file:
        for root, dirs, _ in os.walk(dir_path):
            level = root.replace(dir_path, "").count(os.sep)
            indent = " " * 4 * level
            file.write(f"{indent}{os.path.basename(root)}/\n")
    print(f"Cấu trúc thư mục đã được lưu vào {output_file}")

# Sử dụng hàm với đường dẫn đến thư mục project của bạn
get_folder_structure("D:\\n4k1\\flutter\\fitness_workout_app")
