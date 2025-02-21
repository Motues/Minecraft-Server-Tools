#!/bin/bash
# update_bedrock_server.sh
# Made by Motues with ❤️
# 这是一个用于还原备份MC服务器的脚本, 删除之前更新的版本, 回退到旧版本
# 使用方式:
# ./back_bedrock.sh [backup_file_prefix] [update_file_prefix]
# backup_file_prefix: 备份文件夹的前缀, 默认为 bedrock_server_$(date +%Y%m%d), 例如 bedrock_server_20240220
# update_file_prefix: 最新版本文件夹的前缀, 默认为 bedrock_server


# 设置参数
backup_file_prefix="$1"
update_file_prefix="$2"

# 检查参数,如果不存在则使用默认值
if [ -z "$backup_file_prefix" ]; then
    backup_file_prefix="bedrock_server_$(date +%Y%m%d 2>/dev/null || echo "unknown_date")"
fi

if [ -z "$update_file_prefix" ]; then
    update_file_prefix="bedrock_server"
fi

if [ ! -d "$backup_file_prefix" ]; then
    echo "Error: 备份文件夹不存在, 请检查路径"
    exit 1
fi

echo "======================================================================"
echo "                 需要还原的文件夹: $backup_file_prefix"
echo "                 需要删除的文件夹: $update_file_prefix"
echo "======================================================================"

# 用户确认
read -p "请输入 y 继续, 其他键退出: " input
if [ "$input" != "y" ]; then
    echo "Info: 退出更新"
    exit 0
fi

# 删除新版本
echo "Info: 正在删除 $update_file_prefix 文件夹..."
if [ -d "$update_file_prefix" ]; then
    rm -rf "$update_file_prefix"
    echo "已删除 $update_file_prefix 文件夹"
else
    echo "Warrning: $update_file_prefix 文件夹不存在"
fi

# 还原旧版本
echo "Info: 正在还原$backup_file_prefix文件夹..."
if [ -d "$backup_file_prefix" ]; then
    mv "$backup_file_prefix" "$update_file_prefix"
    echo "已还原$backup_file_prefix文件夹"
else
    echo "Error: $backup_file_prefix 文件夹不存在"
fi
