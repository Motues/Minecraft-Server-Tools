#!/bin/bash
# update_bedrock_server.sh
# Made by Motues with ❤️
# 这是一个更新MC服务器的脚本, 可以自动备份服务器, 并更新服务器版本, 复制配置文件
# 使用方式:
# ./update_bedrock_server.sh [update_file_prefix] [backup_file_prefix]
# update_file_prefix: 最新版本文件夹的前缀, 默认为 bedrock_server
# backup_file_prefix: 备份文件夹的前缀, 默认为 bedrock_server_$(date +%Y%m%d), 例如 bedrock_server_20240220


# 设置文件夹前缀
update_file_prefix="$1"
backup_file_prefix="$2"
not_backup=false

# 检查参数,如果不存在则使用默认值
if [ -z "$backup_file_prefix" ]; then
    backup_file_prefix="bedrock_server_$(date +%Y%m%d 2>/dev/null || echo "unknown_date")"
fi
if [ -z "$update_file_prefix" ]; then
    update_file_prefix="bedrock_server"
fi

# 检查路径是否合理
if [ -d "$backup_file_prefix" ]; then
    echo "Error: 备份文件夹已经存在, 请检查路径, 防止覆盖"
    exit 1
fi
if [ ! -d "$update_file_prefix" ]; then
    echo "Info: 更新文件夹不存在, 将下载最新版服务器, 保存在 $update_file_prefix 文件夹"
    not_backup=true
fi

if ! $not_backup; then
    echo "======================================================================"
    echo "                 需要更新的文件夹: $update_file_prefix"
    echo "                 备份后的文件夹: $backup_file_prefix"
    echo "======================================================================"
fi

# 用户确认
read -p "请输入 y 继续, 其他键退出: " input
if [ "$input" != "y" ]; then
    echo "Info: 退出更新"
    exit 0
fi

# 检测当前系统的包管理器
detect_package_manager() {
    if command -v dnf &>/dev/null; then
        echo "dnf"
    elif command -v yum &>/dev/null; then
        echo "yum"
    elif command -v apt &>/dev/null; then
        echo "apt"
    elif command -v pacman &>/dev/null; then
        echo "pacman"
    elif command -v zypper &>/dev/null; then
        echo "zypper"
    elif command -v apk &>/dev/null; then
        echo "apk"
    elif command -v emerge &>/dev/null; then
        echo "emerge"
    else
        echo "Error: 未知包管理器"
        return 1
    fi
    return 0
}

# 检查并安装依赖
echo "Info: 正在检查环境依赖..."
package_manager=$(detect_package_manager)
# 检查是否安装wget unzip curl screen
sudo $package_manager update > /dev/null 2>&1
if ! command -v wget &>/dev/null; then
    echo "Warning: wget未安装, 正在安装..."
    sudo $package_manager install -y wget > /dev/null 2>&1
fi
if ! command -v unzip &>/dev/null; then
    echo "Warning: unzip未安装, 正在安装..."
    sudo $package_manager install -y unzip > /dev/null 2>&1
fi
if ! command -v curl &>/dev/null; then
    echo "Warning: curl未安装, 正在安装..."
    sudo $package_manager install -y curl > /dev/null 2>&1
fi
if ! command -v screen &>/dev/null; then
    echo "Warning: screen未安装, 正在安装..."
    sudo $package_manager install -y screen > /dev/null 2>&1
fi
echo "- 检查依赖完成"


# 获取下载链接
echo "Info: 正在获取最新版本信息..."
url_mc="https://www.minecraft.net/en-us/download/server/bedrock"
download_link=$(curl --user-agent  "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36" -s "$url_mc" | grep -o 'https://[^"]*bin-linux/bedrock-server-[0-9.]*\.zip' | head -1)

if [ -z "$download_link" ]; then
    echo "Error: 无法获取下载链接, 请检查网络连接或页面结构变化"
    exit 1
fi
echo "- 最新下载链接: $download_link"


# 下载MC服务器
echo "Info: 正在下载最新版本..."
if ! wget  --user-agent="Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36" "$download_link" -O bedrock_server.zip > /dev/null 2>&1 ; then
    echo "Error: 下载失败, 请检查网络连接或下载链接是否有效"
    exit 1
fi


# 备份旧文件
echo "Info:正在备份旧文件..."
if ! $not_backup ; then
    echo "- $update_file_prefix 文件夹已存在, 正在备份..."
    echo "- 备份文件夹名为: $backup_file_prefix"
    mv "$update_file_prefix" "$backup_file_prefix"
    echo "- 备份完成"
else
    echo "- $update_file_prefix 文件夹不存在, 跳过备份步骤"
fi


# 解压MC服务器
echo "Info: 正在解压bedrock_server.zip..."
if [ ! -d "$update_file_prefix" ]; then
    unzip bedrock_server.zip -d $update_file_prefix > /dev/null 2>&1
    rm bedrock_server.zip
    echo "- 解压完成"
else
    echo "$update_file_prefix 文件夹已存在"
    echo "Error: 请手动删除 $update_file_prefix 文件夹后重新运行脚本"
    rm bedrock_server.zip
    exit 1
fi


# 复制配置文件
if $not_backup; then
    echo "Info: 备份文件夹不存在, 跳过复制步骤"
else

    echo "Info: 正在复制配置文件..."
    # server.properties
    if [ -e "$backup_file_prefix/server.properties" ] ; then
        # echo "将 $backup_file_prefix/server.properties 复制到 $update_file_prefix 文件夹"
        cp -f "$backup_file_prefix/server.properties" "$update_file_prefix/server.properties"
        echo "- server.properties 复制完成"
    else
        echo "Warning: 文件 $backup_file_prefix/server.properties 不存在, 跳过复制步骤"
    fi
    # allowlist.json
    if [ -e "$backup_file_prefix/allowlist.json" ]; then
        # echo "将 $backup_file_prefix/allowlist.json 复制到 $update_file_prefix 文件夹"
        cp -f "$backup_file_prefix/allowlist.json" "$update_file_prefix/allowlist.json"
        echo "- allowlist.json 复制完成"
    else
        echo "Warning: 文件 $backup_file_prefix/allowlist.json 不存在, 跳过复制步骤"
    fi
    # permissions.json
    if [ -e "$backup_file_prefix/permissions.json" ]; then
        # echo "将 $backup_file_prefix/permissions.json 复制到 $update_file_prefix 文件夹"
        cp -f "$backup_file_prefix/permissions.json" "$update_file_prefix/permissions.json"
        echo "- permissions.json 复制完成"
    else
        echo "Warning: 文件 $backup_file_prefix/permissions.json 不存在, 跳过复制步骤"
    fi
    # worlds
    if [ -e "$backup_file_prefix/worlds" ]; then
        # echo "将 $backup_file_prefix/worlds 复制到 $update_file_prefix 文件夹"
        cp -rf "$backup_file_prefix/worlds" "$update_file_prefix/worlds"
        echo "- worlds 复制完成"
    else
        echo "Warning: 文件夹 $backup_file_prefix/worlds 不存在, 跳过复制步骤"
    fi

fi


echo "======================================================================"
if $not_backup; then
    echo "     服务器搭建完成, 服务器位于 $update_file_prefix 文件夹"
else
    echo "     服务器更新完成, 服务器位于 $update_file_prefix 文件夹"
fi
echo "======================================================================"