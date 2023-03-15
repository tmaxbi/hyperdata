# visual analytics 시각화

1. install (--set image에 희망하는 이미지를 사용)

   1.1 LoadBalancer 사용시
   ```
   helm install -n hyperdata visualanalytics visualanalytics \
   --set image=192.1.1.93:31234/hyperdata_v20.5_visual_analytics/vis:latest \
   ```

   1.2 NodePort 사용시
   ```
   helm install -n hyperdata visualanalytics visualanalytics \
   --set image=192.1.1.93:31234/hyperdata_v20.5_visual_analytics/vis:latest \
   --set loadBalancer.enabled=false \
   ```

2.  Uninstall virtualization
   ```
   helm uninstall -n hyperdata virtualization-spring virtualization-spring
   ```
