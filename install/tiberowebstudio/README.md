# tibero web studio
### 설명
Tibero Web Studio는 Docker Image로 제공되고 있으며 내부적으로 NginX, Nodejs 가 포함되어 있습니다.

Nodejs version: v14.20.0
### Helm 설치시 Options
- {$image_tag} : tibero web studio 도커 이미지 태그
- {$lsnr_nodeport} : 내부 NginX 연결되어 있으며 Web 포트
- {$proxy_nodeport} : 내부 Nodejs 와 연결되어 있으며 API 포트
### Helm 설치 및 삭제 방법
0. Set Options
1. install tiberowebstudio
  ```
  helm install -n hyperdata tbstudio tbstudio \
  --set image=192.168.179.44:5000/tbstudio_web:{$image_tag} \
  --set service.port.tbsd_lsnr.nodePort={$lsnr_nodeport} \
  --set service.port.tbsd_proxy.nodePort={$proxy_nodeport}
  ```
2. uninstall tiberowebstudio
  ```
  helm install -n hyperdata tbstudio 
  ```
