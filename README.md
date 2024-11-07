# Unichain 노드 돌리는 법~
를 하기 전에~ 콘타보 로그인은 하셨지요? ㅎㅎ

## Unichain 노드 설치하는 방법
```bash
[ -f "unichain.sh" ] && rm unichain.sh; wget -q https://raw.githubusercontent.com/koinlove/unichain/main/unichain.sh && chmod +x unichain.sh && ./unichain.sh
```
위 명령어를 실행하면
![image](https://github.com/user-attachments/assets/59acb97c-ba6a-4062-9f57-6d71b87c6119)
이렇게 뜰 거에요~ 여기서 1번 입력하면 설치 및 실행까지 될 겁니다~

중간에 rpc를 입력하는 곳이 있어요
![image](https://github.com/user-attachments/assets/16d424e1-f6d9-4217-8956-0cf640e0b1b6)
(다른 사진 빌려왔어요 미안~)
이렇게 뜰 건데, sepolia ETH RPC는 뭐냐? 두 가지 방법이 있네요~

1) 공용 rpc를 이용한다
```bash
https://ethereum-sepolia-rpc.publicnode.com
```
얘를 복사해서 붙여 넣으시면 돼요~

2) 프라이빗 rpc를 이용한다
먼저 님 [알케미](https://auth.alchemy.com/?redirectUrl=https%3A%2F%2Fdashboard.alchemy.com)에 들어가서 로그인을 하세용

그러고 새로운 앱을 만들고, 모든 EVM을 enable하게 설정하면(이제 그쯤은 알죠?)
![image](https://github.com/user-attachments/assets/aa2db49b-423c-491a-ba07-8705dae6aca9)
![image](https://github.com/user-attachments/assets/d8e77b2e-dbd7-4651-ab00-5039af60334e)
이렇게 세폴리아로 바꾸고, 
![image](https://github.com/user-attachments/assets/0d2acd64-c399-418e-9e88-ee48b1e9867b)
복사해서 붙여 넣으세용~ 그 뒤의 작업은 알아서 진행될 거에욤ㅎ 

```bash
[ -f "unichain.sh" ] && rm unichain.sh; wget -q https://raw.githubusercontent.com/koinlove/unichain/main/unichain.sh && chmod +x unichain.sh && ./unichain.sh
```
를 입력하시면
![image](https://github.com/user-attachments/assets/1077c540-01fd-43da-b6f3-e2968a2d33ad)
이런 화면이 뜰 텐데, 님의 노드 프라이빗키가 보일 거에요~ 그걸 님 메타마스크에 import하면 그 지갑이 님 메타마스크에 등록이 되겠죠?

이제 [faucet](https://thirdweb.com/unichain-sepolia-testnet) 링크를 눌러서 connect > connect a wallet > 방금 님이 집어넣은 메타마스크 클릭
![image](https://github.com/user-attachments/assets/f5df77a7-9605-47ac-880e-dc87bb695cb1)
이제 faucet 받으면 진짜 완료~

## 로그를 확인하고 싶어요, 잘 돌아가는지 확인하고 시퍼용
```bash
docker logs unichain-node-op-node-1
```
혹은
```bash
docker logs unichain-node-execution-client-1
```
입력하시면 내 유니체인 도커의 로그가 뜨면서 잘 돌아가는지 확인이 될 거에요~

## RPC를 바꾸고 싶어요~
```bash
[ -f "unichain.sh" ] && rm unichain.sh; wget -q https://raw.githubusercontent.com/koinlove/unichain/main/unichain.sh && chmod +x unichain.sh && ./unichain.sh
```
이걸 입력하시면
![image](https://github.com/user-attachments/assets/8b1ed26d-68af-4d62-924c-4e307500e98c)
이렇게 뜰 텐데, 2번을 입력하세요.

![image](https://github.com/user-attachments/assets/16d424e1-f6d9-4217-8956-0cf640e0b1b6)
그러면 이렇게 도커가 종료되고, 새로운 rpc를 입력하는 칸이 뜰 거에요~ 

새로운 rpc를 입력하시면
![image](https://github.com/user-attachments/assets/54a35ed5-5918-46b0-8306-339f6eade0cd)
이렇게 파일이 알아서 수정되고 새로운 rpc로 도커를 재실행할 거에요~

## 유니체인 노드를 재시작하고 싶어요~
```bash
[ -f "unichain.sh" ] && rm unichain.sh; wget -q https://raw.githubusercontent.com/koinlove/unichain/main/unichain.sh && chmod +x unichain.sh && ./unichain.sh
```
를 입력하시면
![image](https://github.com/user-attachments/assets/71e55897-1567-4c88-a2f1-e77a97e2409f)
이런 화면이 뜰 거에요, 3번을 입력하시면 알아서 재시작 될 거에요~


## 유니체인 노드를 삭제하고 싶어요~
```bash
[ -f "unichain.sh" ] && rm unichain.sh; wget -q https://raw.githubusercontent.com/koinlove/unichain/main/unichain.sh && chmod +x unichain.sh && ./unichain.sh
```
를 입력하시면
![image](https://github.com/user-attachments/assets/9b87b2ab-7a1a-48cd-a383-20fe49a41cd4)
이런 화면이 뜰 거에요, 4번을 입력하시면 완료~

[퍼셋 링크](https://thirdweb.com/unichain-sepolia-testnet)
