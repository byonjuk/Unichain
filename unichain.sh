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

echo -e "${CYAN}.env.sepolia 파일 수정 중${NC}"
sed -i "s|^OP_NODE_L1_ETH_RPC=.*|OP_NODE_L1_ETH_RPC=$sepolia_rpc|" "$sepolia_env" 
sed -i "s|^OP_NODE_L1_BEACON=.*|OP_NODE_L1_BEACON=https://ethereum-sepolia-beacon-api.publicnode.com|" "$sepolia_env"

echo -e "${GREEN}수정이 완료되었습니다!${NC}"

echo -e "${CYAN}docker-compose up -d${NC}"
cd ~/unichain-node && docker-compose up -d

echo -e "${CYAN}잘 설정됐는지 확인하기${NC}"
curl -d '{"id":1,"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest",false]}' -H "Content-Type: application/json" http://localhost:8545

echo -e "${RED}노드 설치가 완료됐습니다~ 바로 2번 작업을 해주세요 ㅎㅎ${NC}"
}

node_key() {
node_priv_key=$(cat ~/unichain-node/geth-data/geth/nodekey)
echo -e "${BOLD}${MAGENTA}당신의 유니체인 프라이빗 키 :${NC} ${node_priv_key}"

echo -e "${YELLOW}이제 님의 프라이빗키를 메타마스크 지갑에 넣으세용${NC}"
echo -e "${YELLOW}그러면 님 지갑 주소가 뜨죠? 그걸 https://thirdweb.com/unichain-sepolia-testnet 여기 들어가서 faucet을 받으세요~${NC}"
}

change_rpc_of_unichain() {
echo -e "${CYAN}docker compose down${NC}"
cd ~/unichain-node && docker compose down

# Unichain 구성 파일 경로
sepolia_env=~/unichain-node/.env.sepolia

echo -ne "${BOLD}${MAGENTA}새로운 이더리움 세폴리아 rpc를 입력하세요: ${NC}"
read -e sepolia_rpc

echo -e "${CYAN}.env.sepolia 파일 수정 중${NC}"
sed -i "s|^OP_NODE_L1_ETH_RPC=.*|OP_NODE_L1_ETH_RPC=$sepolia_rpc|" "$sepolia_env" 
sed -i "s|^OP_NODE_L1_BEACON=.*|OP_NODE_L1_BEACON=https://ethereum-sepolia-beacon-api.publicnode.com|" "$sepolia_env"

echo -e "${GREEN}수정이 완료되었습니다!${NC}"

echo -e "${CYAN}docker-compose up -d${NC}"
cd ~/unichain-node && docker-compose up -d

echo -e "${CYAN}잘 설정됐는지 확인하기${NC}"
curl -d '{"id":1,"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest",false]}' -H "Content-Type: application/json" http://localhost:8545

echo -e "${RED}도커가 시작이 안 됐으면 3번을 실행해 주세요~${NC}"
}

restart_unichain() {
echo -e "${CYAN}docker compose down${NC}"
cd ~/unichain-node && docker compose down

echo -e "${CYAN}docker-compose up -d${NC}"
cd ~/unichain-node && docker-compose up -d

echo -e "${CYAN}도커 목록 보여주기!~(2개 뜨면 됨)${NC}"
docker ps

echo -e "${RED}도커가 만약 안 켜졌다면 3번을 다시 실행해 주세요~${NC}"
}

uninstall_unichain() {
echo -e "${BOLD}${CYAN}도커 종료 중..${NC}"
docker stop unichain-node-op-node-1
docker stop unichain-node-execution-client-1

docker rm -f unichain-node-op-node-1
docker rm -f unichain-node-execution-client-1

echo -e "${CYAN}도커 이미지 삭제 중${NC}"
docker rmi us-docker.pkg.dev/oplabs-tools-artifacts/images/op-node:v1.9.1
docker rmi us-docker.pkg.dev/oplabs-tools-artifacts/images/op-geth:v1.101408.0

echo -e "${CYAN}디렉토리 삭제 중...${NC}"
sudo rm -rf ~/unichain-node

echo -e "${RED}유니체인 노드가 깔끔하게 지워졌어요~${NC}"
}
# 메인 메뉴
echo && echo -e "${BOLD}${RED}Unichain Node 설치 명령어 ${NC} by 비욘세제발죽어
${CYAN}원하는 거 고르시고 실행하시고 그러세효. ${NC}
 ———————————————————————
 ${GREEN} 1. 유니체인 노드 설치하기 ${NC}
 ${GREEN} 2. 유니체인 노드 프라이빗키 확인하기(1번 이후 바로 진행 부탁) ${NC}
 ${GREEN} 3. 유니체인 노드 rpc 바꾸기 ${NC}
 ${GREEN} 3. 유니체인 노드 재시작하기 ${NC}
 ${GREEN} 4. 유니체인 노드 삭제하기(기본 명령어 제외) ${NC}
 ———————————————————————" && echo

# 사용자 입력 대기
echo -ne "${BOLD}${MAGENTA} 어떤 작업을 수행하고 싶으신가요? 위 항목을 참고해 숫자를 입력해 주세요: ${NC}"
read -e num

case "$num" in
1)
    install_unichain
    ;;
2)
	node_key
	;;
3)
    change_rpc_of_unichain
    ;;
4)
	restart_unichain
	;;
5)
    uninstall_unichain
    ;;

*)
    echo -e "${BOLD}${RED}이씨이이이이이이이이이이ㅣ이이이이이이이이이이이이이이이이이이이이발개좆븅신같은년아씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발씨발개좆같은년시발년개미친년개쓰레기같은년시발왜그러고살아개씨발좆같다시발십라시발시발시발개븅신같노아놔씨발개좆븅신같은년아죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어${NC}"
	echo -e "${BOLD}${MAGENTA}죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어${NC}"
	echo -e "${BOLD}${BLUE}죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어죽어${NC}"
   ;;
esac