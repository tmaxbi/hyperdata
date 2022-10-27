# tibero web studio
0. Set {$image_tag}
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
