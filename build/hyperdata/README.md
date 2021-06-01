# Hyperdata 이미지 빌드

Hyperdata 이미지를 만들기 위해서는 총 3가지의 Binary가 필요합니다.

1. hyperdata
2. java
3. jeus

관련 Binary들은 Hyperdata QA로부터 전달받았다고 가정합니다.

## Build

1.  각 Binary에 맞는 폴더에 압축해제 합니다. 각 바이너리의 폴더 구조는 다음과 같습니다.
    - Hyperdata
    ```
    $ mkdir src/hyperdata
    $ mv ${HYPERDATA_BINARY} src/hyperdata
    $ cd src/hyperdata
    $ tar -xvf ${HYPERDATA_BINARY}
    $ ls
    README.md  VERSION  config  dist  lib  proauth_po_home  scripts  update_note
    ```

    - Java
    ```
    $ mkdir src/java
    $ mv ${JAVA_BINARY} src/java
    $ cd src/java
    $ tar -xvf ${JAVA_BINARY}
    $ ls
    COPYRIGHT                          THIRDPARTYLICENSEREADME.txt    javafx-src.zip release
    LICENSE                            bin                            jre            src.zip
    README.html                        db                             lib
    THIRDPARTYLICENSEREADME-JAVAFX.txt include                        man
    ```

    - jeus
    ```
    $ mkdir src/jeus
    $ mv ${JEUS_BINARY} src/jeus
    $ cd src/jeus
    $ tar -xvf ${JEUS_BINARY}
    $ ls
    ThirdPartyLicenses.txt  docs  license      setup      version.txt
    derby                   lib   nodemanager  templates
    ```

2. docker 이미지 build 명령어를 수행합니다.
```
# example
$ docker build -t hyperdata8.3_hd_v8.3.4hotpatch:$(date '+%Y%m%d')_v1 .
```


