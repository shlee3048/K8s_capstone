#!/bin/bash


# 이전에 스케일링이 필요한지 여부를 저장한 파일 경로
NEED_SCALE_FILE="/home/ubuntu/k8s/cronjob/need_scale"


# 이전에 스케일링이 필요한지 여부를 읽어옴
NEED_SCALE=$(cat "$NEED_SCALE_FILE")

# 네트워크 지연 임계값 설정 (밀리초)
LATENCY_THRESHOLD=100

# 워커 노드 목록 가져오기
WORKER_NODES=$(kubectl get nodes -o jsonpath='{.items[*].metadata.name}')

# 현재 파드 수 구하기
POD_COUNT=$(kubectl get pods -n default --no-headers=true | wc -l)

# 스케일링 대상 파드 수 구하기
TARGET_POD_COUNT=$(( POD_COUNT / 2 ))

# 워커 노드를 순회하며 네트워크 지연 확인
for NODE in $WORKER_NODES; do
  # 각 워커 노드의 IP 주소를 가져옵니다.
  NODE_IP=$(kubectl get node $NODE -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')

  # ping을 사용하여 해당 노드의 네트워크 지연 시간을 측정합니다.
  LATENCY=$(ping -c 3 -W 1 -q $NODE_IP | tail -1 | awk -F '/' '{print $5}')
  
  PODS=$(kubectl get pods --field-selector=spec.nodeName=$NODE -o jsonpath='{.items[*].metadata.name}' -n default)


  if (( $(echo "$LATENCY > $LATENCY_THRESHOLD" | bc -l) )); then
    # 이전에 스케일링이 필요한지 여부를 저장한 파일에 값을 쓰기
    echo "1" > "$NEED_SCALE_FILE"
    # 네트워크 지연이 임계값보다 높으면 테인트를 적용합니다.
    kubectl taint node $NODE high-latency:NoSchedule --overwrite
    
    # 현재 노드에서 다른 노드로 옮길 수 있는 파드를 확인합니다.
    kubectl delete pod $PODS
    # 필요한 경우 지연 허용 파드에 톨러레이션을 추가하는 로직을 여기에 작성할 수 있습니다.
    

  else
    # 네트워크 지연이 임계값보다 낮으면 테인트를 제거합니다.
    kubectl taint node $NODE high-latency:NoSchedule- >/dev/null 2>&1
  
    # 이전에 스케일링이 필요한지 여부를 저장한 파일의 값을 읽어옴
    if [[ "$NEED_SCALE" -eq "1" ]]; then
      # 스케일링을 통한 재배치 수행
      kubectl scale deployment nginx-deployment --replicas=$TARGET_POD_COUNT
      kubectl scale deployment nginx-deployment --replicas=$POD_COUNT
    
      # 이전에 스케일링이 필요한지 여부를 저장한 파일에 값을 쓰기
      echo "0" > "$NEED_SCALE_FILE"
    fi
  fi
done
