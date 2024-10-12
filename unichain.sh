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

install_unichain() {
# 기본 구성 설치
command_exists() {
    command -v "$1" &> /dev/null
}

# 기본 구성파일 설치

echo -e "${CYAN}서버 업데이트 중...${NC}"
sudo apt update && sudo apt upgrade -y
sudo apt -qy install jq

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
else
    echo -e "${CYAN}Docker Compose is already installed.${NC}"
fi

#unichain 노드 설치하기
echo -e "${CYAN}git clone https://github.com/Uniswap/unichain-node${NC}"
git clone https://github.com/Uniswap/unichain-node

echo -e "${CYAN}cd ~/unichain-node${NC}"
cd ~/unichain-node

# Unichain 구성 파일 경로
sepolia_env=~/unichain-node/.env.sepolia

echo -ne "${BOLD}${MAGENTA}새로운 이더리움 세폴리아 rpc를 입력하세요: ${NC}"
read -e sepolia_rpc

echo -ne "${BOLD}${MAGENTA}새로운 이더리움 세폴리아 beacon api를 입력하세요: ${NC}"
read -e beacon_api

echo -e "${CYAN}.env.sepolia 파일 수정 중${NC}"
sed -i "s|^OP_NODE_L1_ETH_RPC=.*|OP_NODE_L1_ETH_RPC=$sepolia_rpc|" "$sepolia_env" 
sed -i "s|^OP_NODE_L1_BEACON=.*|OP_NODE_L1_BEACON=$beacon_api|" "$sepolia_env"

echo -e "${GREEN}수정이 완료되었습니다!${NC}"

echo -e "${CYAN}docker-compose up -d${NC}"
cd ~/unichain-node && docker-compose up -d

echo -e "${CYAN}잘 설정됐는지 확인하기${NC}"
curl -d '{"id":1,"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest",false]}' -H "Content-Type: application/json" http://localhost:8545

echo -e "${CYAN}임시 저장${NC}"
}

# 메인 메뉴
echo && echo -e "${BOLD}${RED}Unichain Node 설치 명령어 ${NC} by 비욘세제발죽어
${CYAN}원하는 거 고르시고 실행하시고 그러세효. ${NC}
 ———————————————————————
 ${GREEN} 1. 유니체인 노드 설치하기 ${NC}
 ${GREEN} 2. 유니체인 노드 rpc/api 바꾸기 ${NC}
 ${GREEN} 3. 유니체인 노드 삭제하기(기본 명령어 제외) ${NC}
 ———————————————————————" && echo

# 사용자 입력 대기
echo -ne "${BOLD}${MAGENTA} 어떤 작업을 수행하고 싶으신가요? 위 항목을 참고해 숫자를 입력해 주세요: ${NC}"
read -e num

case "$num" in
1)
    install_unichain
    ;;
2)
    change_rpc_of_unichain
    ;;
3)
    uninstall_unichain
    ;;

*)
    echo -e "${BOLD}${RED}그럴 수도 있죠. 다시 실행해 보아요~${NC}"
    ;;
esac