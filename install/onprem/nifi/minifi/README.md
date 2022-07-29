# Minifi
Minifi version=1.16.0 \
Minifi-toolkit version=1.15.3 [minifi-toolkit download link](https://archive.apache.org/dist/nifi/1.15.3/)

**위 링크를 통해서 Minifi-toolkit를 다운받아주세요**

## Minifi 구동방법

**1. Minifi 구동을 위한 설정파일**
  - `bootstrap.conf, config.yml` 두 개의 파일이 필요합니다.
  - `config.yml`은 Nifi 상에서 다운받은 Minifi Template flow 입니다.
  - **Minifi Template flow를 minifi-toolkit을 이용해서 `config.yml`로 변경해줘야합니다.**

**2. Minifi flow를 config.yml로 변환**
  - 다운받은 Minifi-toolkit 압축을 풉니다.
  - 다운받은 template .xml파일을 config.yml로 변환  
  - `./bin/config.sh transform ./{minifi_template.xml} ./{config.yml}`
  - 첫번째 인자는 다운받은 minifi flow파일, 두번째 인자는 변환하여 저장하는 파일입니다.

~~**3. config.yml 파일 수정**~~
  - **Minifi 1.16.0 버전으로 업데이트하면서 해당 작업은 필요없습니다!**
  - ~~Minifi의 버전이 낮아서 충돌을 발생시키는 변수를 제거해야합니다.~~
  - ~~vim/nano 편집기로 config.yml을 열어서 ListFile 프로세서의 아래의 Properties를 제거합니다.~~
  - ~~`et-initial-listing-target`, `et-node-identifier`, `et-state-cache`, `et-time-window`,~~ \
     ~~`listing-strategy`, `max-listing-time`, `max-operation-time`, `max-performance-metrics`, `track-performance`~~

**4. Minifi 컨테이너 구동**
  - 해당 폴더는 Minifi Flow 프로세서 - ListFile에 설정된 Input Directory 
  - `/opt/minifi/{데이터를 전송할 directory Name}` - directory Name과 같은 명의 폴더가 생성되어야 합니다. 
  - `/opt/minifi/{데이터를 백업할 directory Name}` - directory Name과 같은 명의 폴더가 생성되어야 합니다.
  ```
  docker run -v $(pwd)/bootstrap.conf:/opt/minifi/minifi-1.16.0/conf/bootstrap.conf 
             -v $(pwd)/config.yml:/opt/minifi/minifi-1.16.0/conf/config.yml 
             -v {절대경로}/{데이터를 전송할 directory_name}:/opt/minifi/{데이터를 전송할 directory_name} 
             -v {절대경로}/{데이터를 백업할 directory_name}:/opt/minifi/{데이터를 백업할 directory_name}
             --name {데이터를 전송할 directory_name}
             192.168.179.44:5000/hyperdata20.4.0.2.0_nifi-minifi:1.16.0

  ```
  - 위 명령에서 -v 옵션에 들어가는 좌측과 우측 경로는 파일의 **절대경로**여야합니다.
  - 다음 명령어로 minifi docker에 들어가서 `docker exec -it {containerID} /bin/sh`
  - `/opt/minifi/minifi-1.16.0/logs` 해당경로에서 로그를 확인하실 수 있습니다.

**5. 데이터 수집 성공 여부 알람 기능 설정** 
  - 데이터 수집 성공, 실패 관련 정보를 로그로 기록하고 해당 로그를 압축해서 이메일로 전송하는 기능을 제공하기에 사용자는 선택적으로 사용할 수 있습니다.
  - 해당 기능을 사용하기 위해선 MinifiToOzoneFlow 템플릿 하위의 SendEmailFlow 하위로 들어가 putEmail 프로세서의 설정값을 설정해야 합니다.
    - SMTP Username: SMTP 계정의 이메일 주소
    - SMTP Password: SMTP 계정의 비밀번호
    - From: 보내는 계정의 이메일 주소
    - To: 받는 이메일 주소
  - 해당 기능을 사용하기 위해선 SendEmailFlow 프로세스 그룹을 실행해야 합니다.
  - 그 전에 SendEmailFlow의 putEmail 프로세서의 아래 속성값을 설정해야 합니다.
    - SMTP Username: SMTP 계정의 이메일 주소 ex) xxx@gmail.com
    - SMTP Password: SMTP 계정의 비밀번호 ex) 1234
    - From: 보내는 계정의 이메일 주소 ex) xxx@gmail.com
    - To: 받는 이메일 주소 ex) yyy@gmail.com
- 속성값을 다 입력했다면, SendEmailFlow 프로세서 그룹을 실행합니다.

   

~~**6. Minifi 재기동 없이 설정 변경**~~
  - ~~Minifi 내에서 동작하는 flow 등의 설정 정보를 변경해야 할 때마다, 설정을 변경하고 재기동하는 것은 매우 번거롭습니다.~~
  - ~~이에 Minifi는 FileChangeIngestor 라는 방식으로 재기동없이 설정을 변경하는 방법을 제공하고 해당 설정은 bootstrap.conf에 아래와 같이 정의되어 있습니다.~~
```
  nifi.minifi.notifier.ingestors=org.apache.nifi.minifi.bootstrap.configuration.ingestors.FileChangeIngestor
  nifi.minifi.notifier.ingestors.file.config.path = /opt/minifi/minifi-1.16.0/conf/newConfig.yml
  nifi.minifi.notifier.ingestors.file.polling.period.seconds = 5
```
  - ~~Minifi의 설정을 변경하고 싶을 경우 **config.yml이 아닌** newConfig.yml을 수정해야 합니다.~~
  - ~~데이터를 수집하는 경로를 변경하고 싶을 경우 newConfig.yml의 아래 부분을 수정합니다.~~
  - ~~수정 할 때 경로는 폴더의 **절대경로**여야 합니다.~~
```
  Processors:
      Properties:
          Input Directory: {/opt/minifi/minifi-1.16.0/conf/data_transfer_test}
    
```


   
