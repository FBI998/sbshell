#!/bin/bash

# 定义颜色
GREEN='\033[0;32m'
NC='\033[0m' # 无颜色

# 检查 sing-box 是否已安装
if ! command -v sing-box &> /dev/null; then
    echo "请安装 sing-box 后再执行。"
    sudo bash /etc/sing-box/scripts/install_singbox.sh
    exit 1
fi

# 停止 sing-box 服务
function stop_singbox() {
    sudo systemctl stop sing-box
    if ! systemctl is-active --quiet sing-box; then
        echo "sing-box 已停止" >/dev/null
    else
        exit 1
    fi
}

# 清理防火墙规则
function clean_firewall() {
    sudo bash /etc/sing-box/scripts/clean_nft.sh
}

# 切换模式的逻辑
echo "切换模式开始...请根据提示输入操作。"

# 选择模式
read -p "请选择模式（1: TProxy 模式, 2: TUN 模式）: " mode_choice

case $mode_choice in
    1)
        stop_singbox
        clean_firewall
        echo "MODE=TProxy" | sudo tee /etc/sing-box/mode.conf > /dev/null
        echo -e "${GREEN}当前选择模式为：TProxy 模式${NC}"
        ;;
    2)
        stop_singbox
        clean_firewall
        echo "MODE=TUN" | sudo tee /etc/sing-box/mode.conf > /dev/null
        echo -e "${GREEN}当前选择模式为：TUN 模式${NC}"
        ;;
    *)
        echo -e "${RED}无效的选择${NC}"
        exit 1
        ;;
esac
