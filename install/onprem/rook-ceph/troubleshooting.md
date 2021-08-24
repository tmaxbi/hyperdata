# Issues

## rook-ceph-osd-prepare가 실패하거나 끝나지 않고 Running일 경우
1. 노드간 시간동기화가 되어 있지 않을 경우, 정상동작하지 않을 수 있습니다.

1.1. worker node에서 ntp 확인
<pre>
[root@worker1]# datetimectl
      Local time: 화 2021-08-24 17:21:45 KST
  Universal time: 화 2021-08-24 08:21:45 UTC
        RTC time: 화 2021-08-24 08:21:45
       Time zone: Asia/Seoul (KST, +0900)
     NTP enabled: <b>no</b>
NTP synchronized: <b>no</b>
 RTC in local TZ: no
      DST active: n/a
</pre>

1.2. master node에 ntp 설치
```
[root@master]# yum install ntp
[root@master]# systemctl enable ntp
[root@master]# systemctl start ntp

```

1.3. worker node와 master node ntp 동기화
```
[root@worker1]# yum install ntp
[root@worker1]# systemctl enable ntp
[root@worker1]# systemctl start ntp
[root@worker1]# vi /etc/ntp.conf
    ...
    # server 0.centos.pool.ntp.org iburst
    # server 1.centos.pool.ntp.org iburst
    # server 2.centos.pool.ntp.org iburst
    # server 3.centos.pool.ntp.org iburst
    server ${MASTER_NODE_IP} (ex. server 192.168.179.31)
    ...

[root@worker1]# timedatectl set-ntp true
```