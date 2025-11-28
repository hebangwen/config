#!/bin/bash

# 定义颜色输出
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}>>> 开始执行 Oh-My-Zsh 一键安装与配置脚本...${NC}"

# 1. 前置检查
# -------------------------------------------
echo -e "${YELLOW}>>> 正在检查必要工具...${NC}"

if ! command -v git &> /dev/null; then
    echo -e "${RED}错误: 未找到 git，请先安装 git。${NC}"
    exit 1
fi

if ! command -v curl &> /dev/null; then
    echo -e "${RED}错误: 未找到 curl，请先安装 curl。${NC}"
    exit 1
fi

if ! command -v zsh &> /dev/null; then
    echo -e "${RED}错误: 未找到 zsh，请先安装 zsh (例如: sudo apt install zsh 或 brew install zsh)。${NC}"
    exit 1
fi

# 检查当前目录下是否存在 venv.zsh-theme
if [ ! -f "./venv.zsh-theme" ]; then
    echo -e "${RED}错误: 当前目录下未找到 'venv.zsh-theme' 文件。请确保该文件存在。${NC}"
    exit 1
fi

# 2. 安装 Oh-My-Zsh (如果未安装)
# -------------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${GREEN}>>> 正在安装 Oh-My-Zsh...${NC}"
    # 使用 --unattended 参数避免安装后直接进入 zsh 导致脚本中断
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${YELLOW}>>> Oh-My-Zsh 已安装，跳过安装步骤。${NC}"
fi

# 定义自定义目录路径
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# 3. 安装插件
# -------------------------------------------
echo -e "${GREEN}>>> 正在安装插件...${NC}"

# 安装 zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
    echo "正在克隆 zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
else
    echo "zsh-autosuggestions 已存在，跳过。"
fi

# 安装 zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
    echo "正在克隆 zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
else
    echo "zsh-syntax-highlighting 已存在，跳过。"
fi

# 4. 拷贝自定义主题
# -------------------------------------------
echo -e "${GREEN}>>> 正在配置自定义主题 venv...${NC}"
cp ./venv.zsh-theme "$ZSH_CUSTOM/themes/"
echo "已将 venv.zsh-theme 拷贝至 $ZSH_CUSTOM/themes/"

# 5. 修改 .zshrc 配置
# -------------------------------------------
ZSHRC="$HOME/.zshrc"

# 备份 .zshrc
cp "$ZSHRC" "${ZSHRC}.bak.$(date +%s)"
echo "已备份原配置为 ${ZSHRC}.bak.$(date +%s)"

# 判断操作系统类型以适配 sed 命令 (macOS 的 sed 写法略有不同)
OS="$(uname)"
if [ "$OS" == "Darwin" ]; then
    # macOS
    SED_CMD="sed -i ''"
else
    # Linux
    SED_CMD="sed -i"
fi

# 修改主题为 venv
# 查找 ZSH_THEME="..." 并替换
$SED_CMD 's/^ZSH_THEME=".*"/ZSH_THEME="venv"/' "$ZSHRC"

# 启用插件
# 注意：这里假设 .zshrc 是默认生成的，包含 plugins=(git)。
# 我们将其替换为包含新插件的列表。
if grep -q "plugins=(git)" "$ZSHRC"; then
    $SED_CMD 's/^plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$ZSHRC"
else
    # 如果用户已经修改过插件列表，使用追加模式可能会破坏格式，这里做保守处理
    echo -e "${YELLOW}警告: 未在 .zshrc 中找到默认的 'plugins=(git)' 配置。${NC}"
    echo -e "${YELLOW}请手动编辑 ~/.zshrc，确保 plugins 列表中包含: zsh-autosuggestions zsh-syntax-highlighting${NC}"
fi

echo -e "${GREEN}>>> 配置更新完成。${NC}"

# 6. 更改默认 Shell 并提示
# -------------------------------------------
CURRENT_SHELL=$(basename "$SHELL")
if [ "$CURRENT_SHELL" != "zsh" ]; then
    echo -e "${YELLOW}>>> 正在尝试将默认 Shell 切换为 zsh (可能需要输入密码)...${NC}"
    chsh -s "$(which zsh)"
fi

echo -e "${GREEN}======================================================${NC}"
echo -e "${GREEN}   安装与配置全部完成！ ${NC}"
echo -e "${GREEN}   当前主题已设置为: venv ${NC}"
echo -e "${GREEN}   已安装插件: zsh-autosuggestions, zsh-syntax-highlighting ${NC}"
echo -e "${GREEN}======================================================${NC}"
echo -e "${YELLOW}请执行以下命令立即生效：${NC}"
echo -e "    source ~/.zshrc"
echo -e "${YELLOW}或者直接输入 'zsh' 进入新环境。${NC}"
