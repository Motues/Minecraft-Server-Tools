#!/bin/bash
# backup_bedrock_server.sh
# Made by Motues with ❤️
# 这是一个备份MC服务器的脚本, 可以自动备份服务器
# 使用方式:
# ./backup_bedrock_server.sh [server_file_prefix] [backup_file_prefix]
# server_file_prefix: 服务器文件夹的前缀, 默认为 bedrock_server
# backup_file_prefix: 备份文件夹的前缀, 默认为 bedrock_server_$(date +%Y%m%d), 例如 bedrock_server_20240220

# 设置文件夹前缀
server_file_prefix="$1"
backup_file_prefix="$2"

# 检查参数,如果不存在则使用默认值
if [ -z "$backup_file_prefix" ]; then
    backup_file_prefix="bedrock_server_$(date +%Y%m%d 2>/dev/null || echo "unknown_date")"
fi
if [ -z "$server_file_prefix" ]; then
    server_file_prefix="bedrock_server"
fi

# 检查路径是否合理
if [ -d "$backup_file_prefix" ]; then
    echo "Error: 备份文件夹已经存在, 请检查路径, 防止覆盖"
    exit 1
fi
if [ ! -d "$server_file_prefix" ]; then
    echo "Error: 服务器文件夹不存在, 请检查路径"
    exit 1
fi

echo "======================================================================"
echo "                 服务器所在文件夹: $server_file_prefix"
echo "                 备份后的文件夹: $backup_file_prefix"
echo "======================================================================"


# 用户确认
read -p "请输入 y 继续, 其他键退出: " input
if [ "$input" != "y" ]; then
    echo "Info: 退出更新"
    exit 0
fi

# 备份文件
echo "Info: 正在备份服务器..."
if [ -d "$server_file_prefix" ]; then
    cp -rf "$server_file_prefix" "$backup_file_prefix"
    echo "备份完成"
else
    echo "Error: 服务器文件夹不存在"
fi