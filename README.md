# Minecraft-Server-Tools


![Shell Script](https://img.shields.io/badge/Shell_Script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)


## 📖 项目概述

我的世界服务器脚本工具，可以完成服务器的自动更新、备份、配置迁移、回档等操作，方便用户便捷管理服务器，目前适用于linux操作系统。

该脚本提供以下核心功能：  
✅ 一键更新服务器版本  
✅ 智能备份与配置迁移  
✅ 安全回滚机制

## 🛠️ 工具使用指南

### 🔄 服务器更新脚本 `update_bedrock_server.sh`
```bash
# 基础用法（自动生成备份目录）
./update_bedrock_server.sh

# 自定义目录结构
./update_bedrock_server.sh [更新目录] [备份目录]
```
**参数说明**
* 更新目录：指定新版本服务器的存放路径（默认：bedrock_server）
* 备份目录：指定旧版本备份路径（默认：bedrock_server_YYYYMMDD）


### ⏮️ 服务器回滚脚本 `back_bedrock_server.sh`

```bash
# 恢复最近备份
./back_bedrock_server.sh

# 指定特定备份版本
./back_bedrock_server.sh [备份目录] [替换目录]
```

**参数说明**
* 备份目录：指定要恢复的备份路径（默认：bedrock_backup_YYYYMMDD）
* 替换目录：指定要替换的目录（默认：bedrock_server）

### 💾 备份脚本 `backup_bedrock_server.sh`
```bash
# 基础用法（默认备份目录）
./backup_bedrock_server.sh

# 自定义目录结构
./backup_bedrock_server.sh [服务器目录] [备份后目录]
```

**参数说明**
* 服务器目录：指定要备份的服务器路径（默认：bedrock_server）
* 备份后目录：指定备份后要存放的目录（默认：bedrock_backup_YYYYMMDD）

## 🚀 参考实践

### 更新
假设你的服务器目录为 `~/Minecraft/bedrock_server`，备份后的目录为 `bedrock_backup`

首先将脚本拷贝到服务器所在的目录下
```bash
git clone https://github.com/Motues/Minecraft-Server-Tools.git
cp Minecraft-Server-Tools/linux/bedrock/update_bedrock_server.sh ~/Minecraft
cp Minecraft-Server-Tools/linux/bedrock/back_bedrock_server.sh ~/Minecraft
cp Minecraft-Server-Tools/linux/bedrock/backup_bedrock_server.sh ~/Minecraft
```

在切换到服务器目录`~/Minecraft/`，执行以下命令便可以更新服务器的版本，完成备份
```bash
cd ~/Minecraft
./update_bedrock_server.sh bedrock_server bedrock_backup
```
之后便会在当前目录生成一个备份文件夹`bedrock_backup`，并自动将配置文件迁移到新版服务器目录`bedrock_server`中

最后启动服务器
```bash
cd bedrock_server
./bedrock_server
```

### 回档

在服务器目录`~/Minecraft/`下执行以下命令即可完成回档，不更新服务器
```bash
./back_bedrock_server.sh bedrock_backup bedrock_server
```

### 备份
在服务器目录`~/Minecraft/`下执行以下命令即可完成备份
```bash
./backup_bedrock_server.sh bedrock_server bedrock_backup 
```

## ⚠️ 注意事项
1. 如果没有权限时需要给脚本添加执行权限
    ```bash
    chmod +x update_bedrock_server.sh
    chmod +x back_bedrock_server.sh
    ```
    在更新软件包的时可能需要管理员权限
2. 建议在`screen`的虚拟控制台中启动服务器，方便后台运行
    ```bash
    screen -S MC_bedrock
    cd ~/Minecraft/bedrock_server
    ./bedrock_server
    ```
3. Minecraft的服务器文件无法直接通过`wget`下载，因此我们要模拟浏览器的请求，这也是本项目的处理方法
    ```bash
    wget  --user-agent="Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36" "$download_link"
    ```
4. 因为每个服务器安装的行为包等不同，并且每个版本服务器默认安装的也不同，为防止更新后出现不兼容情况，服务器的行为包等需要自己手动安装。如果在更新后出现任何兼容性问题，请立刻回档。

## 📝 TODO

* 完成Java 版本的更新脚本
* 尝试完成Windows版本的更新脚本

欢迎通过Issue提交建议！

> Made by [Motues](https://github.com/Motues) with ❤️