#!/bin/bash
# ======================================================================================================================
# Scripts - Deploy - Dev - Linux - Ubuntu - Network
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Environment
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

      # ----------------------------------------------------------------------------------------------------------------
      # Kernel
      # ----------------------------------------------------------------------------------------------------------------

      # >>>> Kernel
      echo ">>>> Linux - Kernel : $(uname -r)"
      echo

      sudo systemctl daemon-reload
      echo

      local NOW_KERNEL_VERSION=$(uname -r | cut -d '-' -f 1,2)
      local DEL_KERNEL_VERSION=$(dpkg --list | grep linux-image- |grep -v "linux-image-${OLD_KERNEL_VERSION}" | grep -v linux-image-generic-hwe |awk  '{print $2}')

      if [ "${DEL_KERNEL_VERSION}" ]; then
        dpkg --list | grep linux-image
        echo

        echo "sudo apt-get purge -y ${DEL_KERNEL_VERSION} -f"
        echo
      fi

      # >>>> Kernel - Network - ipv4
      sudo sysctl -w net.ipv4.icmp_echo_ignore_all=1
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # Hosts
      # ----------------------------------------------------------------------------------------------------------------

      # >>>> Hosts
      local PROJECT_HOST_NAME
      PROJECT_HOST_NAME=$(sudo grep -i "localhost" /etc/hosts | awk '{print $2}' | head -n 1)
      if [ ! "${PROJECT_HOST_NAME}" ]; then
        echo ">>>> Linux - Hosts"
        echo

        echo $'\n127.0.0.1 localhost' | sudo tee -a /etc/hosts
        echo

        sudo grep -v '#' /etc/hosts
        echo
      fi

      echo ">>>> Linux - Network - Firewall"
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # UFW
      # ----------------------------------------------------------------------------------------------------------------

      local addPackageList="ufw ebtables"
      for pkgItem in ${addPackageList}; do
        local APT_PKG_INFO
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
          sudo apt install -y "${pkgItem}"
          sudo systemctl enable "${pkgItem}"
          sudo systemctl start "${pkgItem}"
          echo
        fi
      done

      local UFW_STATUS
      UFW_STATUS=$(systemctl is-active ufw)
      if [ "${UFW_STATUS}" == "active" ]; then
        sudo ufw logging off
        sudo ufw disable
      fi

      # >>>> Reset current rules
      sudo ufw --force reset
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # UFW - default
      # ----------------------------------------------------------------------------------------------------------------

      # >>>> Incoming
      sudo ufw default deny incoming
      # >>>> Outgoing
      sudo ufw default allow outgoing
      # >>>> Forwarding Policy
      #sudo sed -i 's/^DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw
      # >>>> Logging
      sudo ufw logging on
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # UFW - incoming traffic
      # ----------------------------------------------------------------------------------------------------------------

      # >>>> Update allowed services
      sudo ufw allow domain comment "DNS"
      sudo ufw allow ntp comment 'NTP'

      # >>>> Update allowed ports for App      - PHP
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 9001 proto tcp comment 'PHP - Xdebug - DBGp Proxy'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 9003 proto tcp comment 'PHP - Xdebug'

      # >>>> Update allowed ports for App      - Symfony Local Server
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8000 proto tcp comment 'Symfony Local server'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8081 proto tcp comment 'Symfony Local server - App 1'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8082 proto tcp comment 'Symfony Local server - App 2'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8083 proto tcp comment 'Symfony Local server - App 3'

      # >>>> Update allowed ports for Cache    - Redis
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 6379 proto tcp comment 'Redis'

      # >>>> Update allowed ports for Database - PostgreSQL
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 5432 proto tcp comment 'PostgreSQL'

      # >>>> Update allowed ports for Message  - RabbitMQ
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 5672  proto tcp comment 'RabbitMQ'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 5552  proto tcp comment 'RabbitMQ - stream'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 15672 proto tcp comment 'RabbitMQ - http'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 25672 proto tcp comment 'RabbitMQ - clustering'

      # >>>> Update allowed ports for Server   - Nginx
      sudo ufw allow http  comment 'Nginx - HTTP'
      sudo ufw allow https comment 'Nginx - HTTPS'

      # >>>> Update allowed ports for Tools    - Docker
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8080 comment 'Docker - WebApp'
      sudo ufw allow from 172.17.0.0/16

      # >>>> Private Network - Inbound Traffic
      #sudo ufw deny from 10.0.0.0/8
      #sudo ufw deny from 192.168.0.0/16
      #sudo ufw deny from 192.168.0.0/24
      #sudo ufw deny from 192.168.55.0/24

      # >>>> UFW - Outgoing traffic - Private Network - Outbound Traffic
      sudo ufw deny from any to any port 1                  # TCP Port Service Multiplexer (TCPMUX) - 비정상 트래픽 스캔 대상
      sudo ufw deny from any to any port 7                  # Echo - DoS 공격(Echo-Chargen)에 악용 가능
      sudo ufw deny from any to any port 9                  # Discard - 자원 소모 공격 타겟
      sudo ufw deny from any to any port 13                 # Daytime - 시스템 시간 및 정보 유출 방지
      sudo ufw deny from any to any port 17                 # Quote of the Day (QOTD) - 취약한 고전 서비스
      sudo ufw deny from any to any port 19                 # Character Generator (Chargen) - DDoS 증폭 공격에 자주 이용됨
      sudo ufw deny from any to any port 20                 # FTP (Data) - 암호화되지 않은 파일 전송(데이터 채널)
      sudo ufw deny from any to any port 21                 # FTP (Control) - 암호화되지 않은 로그인 정보 노출 위험
      sudo ufw deny from any to any port 22                 # SSH - 원격 접속 (특정 IP만 허용하는 화이트리스트 방식 권장)
      sudo ufw deny from any to any port 23                 # Telnet - 암호화되지 않은 원격 접속 (절대 금지)
      sudo ufw deny from any to any port 24                 # Private Mail System - 사용되지 않는 사설 메일 포트
      sudo ufw deny from any to any port 69                 # TFTP (Trivial FTP) - 인증 없는 간이 파일 전송 프로토콜
      sudo ufw deny from any to any port 70                 # Gopher - 아주 오래된 정보 검색 서비스
      sudo ufw deny from any to any port 111                # RPCbind - 네트워크 서비스 정보 및 취약점 노출 위험
      sudo ufw deny from any to any port 123 proto udp      # NTP - NTP 증폭 DDoS 공격 방어
      sudo ufw deny from any to any port 135                # NetBIOS (RPC Endpoint Mapper) - 윈도우 기반 원격 취약점 노출
      sudo ufw deny from any to any port 137                # NetBIOS (Name Service) - 내부 네트워크 이름 정보 유출
      sudo ufw deny from any to any port 138                # NetBIOS (Datagram Service) - 파일 공유 관련 취약점
      sudo ufw deny from any to any port 139                # NetBIOS (Session Service) - 윈도우 시스템 정보 노출 위험
      sudo ufw deny from any to any port 161                # SNMP (Simple Network Management Protocol) - 장비 모니터링 정보 유출
      sudo ufw deny from any to any port 162                # SNMP Trap - 관리 장비로의 비정상 트래픽 전송 차단
      sudo ufw deny from any to any port 445                # Microsoft-DS (SMB) - 랜섬웨어(WannaCry 등) 전파 핵심 포트
      sudo ufw deny from any to any port 514                # Syslog - 외부로 로그가 유출되어 시스템 구조 노출 방지
      sudo ufw deny from any to any port 515                # LPD (Line Printer Daemon) - 인쇄 서비스 취약점 방어
      sudo ufw deny from any to any port 540                # UUCP (Unix-to-Unix Copy) - 고전적인 유닉스 간 파일 복사
      sudo ufw deny from any to any port 542                # Commerce Applications - 오래된 상거래 프로토콜
      sudo ufw deny from any to any port 591                # FileMaker Web Publishing - 특정 데이터베이스 웹 서비스 노출 차단
      sudo ufw deny from any to any port 636                # LDAPS (LDAP over SSL) - 디렉토리 서비스 정보 유출 방지
      sudo ufw deny from any to any port 873                # Rsync - 인증되지 않은 사용자의 파일 시스템 동기화 방지
      sudo ufw deny from any to any port 981                # Checkpoint Firewall GUI - 관리 인터페이스 외부 노출 차단
      sudo ufw deny from any to any port 990                # FTPS (Implicit) - 암호화된 FTP 제어 신호
      sudo ufw deny from any to any port 992                # Telnet over SSL - 암호화된 텔넷 (현대 보안 미충족)
      sudo ufw deny from any to any port 1080               # SOCKS Proxy - 익명 프록시로 악용되는 것을 방지
      sudo ufw deny from any to any port 1900               # SSDP (UPnP) - 로컬 장치 검색 프로토콜, DDoS 증폭 공격 타겟
      sudo ufw deny from any to any port 3690               # SVN (Subversion) - 소스 코드 관리 시스템 포트 노출 차단
      sudo ufw deny from any to any port 4369               # Erlang Port Mapper Daemon (EPMD) - RabbitMQ 등 관련 노드 정보 노출
      sudo ufw deny from any to any port 5228               # Google Play Services - 서버 환경에서 불필요한 구글 서비스 통신 차단
      sudo ufw deny from any to any port 5551               # OpenTofu/Terraform/Dev tools 관련 - 불필요한 관리 서비스 노출 방지
      sudo ufw deny from any to any port 5552               # 기타 개발 툴용 포트 스캔 방어
      sudo ufw deny from any to any port 17500              # Dropbox LanSync - 서버 내 불필요한 개인용 동기화 서비스 차단

      # >>>> UFW - Remote Desktop
      #sudo ufw allow from 192.168.0.0/24 to 192.168.0.0/24 port 3389 proto tcp comment 'Remote Desktop'

      sudo ufw deny from any to any port 2049               # NFS
      sudo ufw deny from any to any port 2222               # Common SSH Alt
      sudo ufw deny from any to any port 2323               # Alternative Telnet
      sudo ufw deny from any to any port 2324               # Alternative Telnet
      sudo ufw deny from any to any port 3389               # RDP
      sudo ufw deny from any to any port 3390               # RDP Alt
      sudo ufw deny from any to any port 3478               # STUN
      sudo ufw deny from any to any port 5000               # Common Dev Port
      sudo ufw deny from any to any port 5222               # XMPP
      sudo ufw deny from any to any port 5631               # PCAnywhere
      sudo ufw deny from any to any port 5632               # PCAnywhere
      sudo ufw deny from any to any port 5800               # VNC HTTP
      sudo ufw deny from any to any port 5900               # VNC
      sudo ufw deny from any to any port 5903               # VNC
      sudo ufw deny from any to any port 5938               # TeamViewer
      sudo ufw deny from any to any port 6556               # Checkmk
      sudo ufw deny from any to any port 7070               # AnyDesk
      sudo ufw deny from any to any port 10000              # Webmin
      sudo ufw deny from any to any port 12975              # PCAnywhere
      sudo ufw deny from any to any port 32976              # PCAnywhere

      # >>>> UFW - DevOps & Container Risks (Critical in Cloud)
      sudo ufw deny from any to any port 2375               # Docker API (Unencrypted) - 루트 권한 탈취 위험
      sudo ufw deny from any to any port 2376               # Docker API (TLS) - 외부 노출 시 위험
      sudo ufw deny from any to any port 6443               # Kubernetes API Server - 클러스터 제어권 보호
      sudo ufw deny from any to any port 10250              # Kubelet API - 컨테이너 조작 방지
      #sudo ufw deny from any to any port 8080               # Jenkins/Tomcat/Alt HTTP - 관리 도구 노출 방지

      # >>>> UFW - Additional Remote Management & Panels
      sudo ufw deny from any to any port 2082               # cPanel - 호스팅 관리 패널 (HTTP)
      sudo ufw deny from any to any port 2083               # cPanel - 호스팅 관리 패널 (HTTPS)
      sudo ufw deny from any to any port 2086               # WHM - 웹 호스트 관리자 (HTTP)
      sudo ufw deny from any to any port 2087               # WHM - 웹 호스트 관리자 (HTTPS)
      sudo ufw deny from any to any port 5985               # WinRM (HTTP) - 윈도우 원격 관리 프로토콜
      sudo ufw deny from any to any port 5986               # WinRM (HTTPS) - 윈도우 원격 관리 프로토콜

      # >>>> UFW - Data Stores & Amplification Vectors
      sudo ufw deny from any to any port 3128               # Squid Proxy - 프록시 서버 악용 방지
      sudo ufw deny from any to any port 8888               # Jupyter/Alt HTTP - 데이터 분석 도구 보호
      sudo ufw deny from any to any port 9200               # Elasticsearch - 데이터 유출 및 랜섬웨어 타겟
      sudo ufw deny from any to any port 11211              # Memcached - UDP 증폭 DDoS 공격 악용 방지
      sudo ufw deny from any to any port 27017              # MongoDB - 인증 없는 DB 접근 차단

      sudo ufw deny out rsync
      sudo ufw deny out ldap

      # >>>> UFW - Enable
      echo
      sudo ufw disable
      sudo ufw enable
      echo

      sudo ufw status verbose
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # ebtables - Mac Address
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> Linux - Network - ebtables - mac address"
      echo

      sudo arp -a
      echo

      sudo ebtables -F

      # >>>> Network - Firewall - IPv6

      sudo ebtables -A INPUT -p IPv6 -j DROP
      sudo ebtables -A FORWARD -p IPv6 -j DROP
      sudo ebtables -A OUTPUT -p IPv6 -j DROP

      # >>>> Network - Firewall - IPv4

      sudo ebtables -D INPUT -p icmp --icmp-type echo-request -j DROP

      sudo ebtables -A INPUT -p ARP --arp-opcode ! 1 --arp-opcode ! 2 -j DROP
      sudo ebtables -A INPUT -d Multicast --log-level info --log-prefix "EBFW_MCAST_DROP: " -j DROP

      sudo ebtables -A OUTPUT -p IPv4 --ip-proto udp --ip-sport 67 -j DROP

      sudo ebtables -A INPUT -p IPv4 --ip-dst 224.0.0.251 -j ACCEPT

      # >>>> Devices

      #sudo ebtables -A INPUT -s xx:xx:xx:xx:xx:xx -j DROP
      #sudo ebtables -A FORWARD -s xx:xx:xx:xx:xx:xx -j DROP
      #sudo ebtables -A OUTPUT -d xx:xx:xx:xx:xx:xx -j DROP

      sudo ebtables -L
      echo
    fi
fi
