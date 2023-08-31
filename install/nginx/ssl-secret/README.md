# nginx SSL인증을 위한 Secret 생성 파일

1. Create ssl-secret

   ```
   helm install -n hyperdata ssl-secret ssl-secret
   --set tlsSecret.certFile=tls.crt \
   --set tlsSecret.keyFile=tls.key \
   ```
   #### 유의사항
   - namespace nginx와 똑같게 설정
   - ssl인증서 ssl-secret폴더 안에서 생성 필수!


2. Uninstall ssl-secret
```
helm uninstall -n hyperdata ssl-secret
```
