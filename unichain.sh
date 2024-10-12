#!/bin/bash

BOLD='\033[1m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
CYAN='\033[36m'
MAGENTA='\033[35m'
NC='\033[0m'

# 한국어 체크하기
check_korean_support() {
    if locale -a | grep -q "ko_KR.utf8"; then
        return 0  # Korean support is installed
    else
        return 1  # Korean support is not installed
    fi
}

# 한국어 IF
if check_korean_support; then
    echo -e "${CYAN}한글있긔 설치넘기긔.${NC}"
else
    echo -e "${CYAN}한글없긔, 설치하겠긔.${NC}"
    sudo apt-get install language-pack-ko -y
    sudo locale-gen ko_KR.UTF-8
    sudo update-locale LANG=ko_KR.UTF-8 LC_MESSAGES=POSIX
    echo -e "${CYAN}설치 완료했긔.${NC}"
fi

# 기본 구성 설치

command_exists() {
    command -v "$1" &> /dev/null
}

echo -e "${CYAN}${NC}"
echo -e "${CYAN}서버 업데이트 중...${NC}"
sudo apt update && sudo apt upgrade -y

echo -e "${BOLD}${CYAN}Checking for Docker installation...${NC}"
if ! command_exists docker; then
    echo -e "${RED}Docker is not installed. Installing Docker...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    echo -e "${CYAN}Docker installed successfully.${NC}"
else
    echo -e "${CYAN}Docker is already installed.${NC}"
fi

if ! command_exists docker-compose; then
    echo -e "${RED}Docker Compose is not installed. Installing Docker Compose...${NC}"
    # Docker Compose의 최신 버전 다운로드 URL
    sudo curl -L https://github.com/docker/compose/releases/download/$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose
    sudo chmod 755 /usr/bin/docker-compose
    echo -e "${CYAN}Docker Compose installed successfully.${NC}"
fi

echo -e "${CYAN}git clone https://github.com/Uniswap/unichain-node${NC}"
git clone https://github.com/Uniswap/unichain-node

echo -e "${CYAN}cd unichain-node${NC}"
cd unichain-node