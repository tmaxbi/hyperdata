# Issues

## Envoy proxy is NOT ready: config not received from Pilot가 뜰 경우
1. helm delete로 istio를 삭제해도 secret은 삭제가 되지 않습니다. 이때, 다시 helm install할 경우, 이전 secret을 certificate로 사용하게 되어 통신이 제대로 수행되지 않을 수 있습니다. istio 재설치 시 namespace를 삭제하고 다시 설치하길 권장드립니다.
