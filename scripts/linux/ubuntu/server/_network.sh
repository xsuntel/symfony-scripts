#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Network
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
    echo ">>>> Operating System"
    echo

    local addPackageList="ufw"
    for pkgItem in ${addPackageList}; do
      local APT_PKG_INFO
      APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
      if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
        sudo apt install -y ${pkgItem}
        sudo systemctl enable ${pkgItem}
        sudo systemctl start ${pkgItem}
        echo
      fi
    done

    # >>>> Stop the process
    local UFW_STATUS
    UFW_STATUS=$(systemctl is-active ufw)
    if [ "${UFW_STATUS}" == "active" ]; then
      sudo ufw logging off
      sudo ufw disable
    fi

    # >>>> Reset current rules
    sudo ufw --force reset
    echo

    # ------------------------------------------------------------------------------------------------------------------
    # UFW - default
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Incoming
    sudo ufw default deny incoming
    # >>>> Outgoing
    sudo ufw default allow outgoing
    # >>>> Logging
    sudo ufw logging on
    echo

    # ------------------------------------------------------------------------------------------------------------------
    # UFW - incoming
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> Update allowed services
    sudo ufw allow domain comment "DNS"
    sudo ufw allow ntp comment 'NTP'

    # >>>> Update allowed ports for App      - PHP
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 9001 proto tcp comment 'PHP - Xdebug - DBGp Proxy'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 9003 proto tcp comment 'PHP - Xdebug'

      # >>>> Symfony Local Server
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8000 proto tcp comment 'Local server - 00'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8010 proto tcp comment 'Local server - 10'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8020 proto tcp comment 'Local server - 20'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8030 proto tcp comment 'Local server - 30'
    fi

    # >>>> Update allowed ports for Cache    - Redis
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 6379 proto tcp comment 'Redis'
    else
      sudo ufw allow 6379/tcp comment 'Redis'
    fi

    # >>>> Update allowed ports for Database - PostgreSQL
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 5432 proto tcp comment 'PostgreSQL'
    else
      sudo ufw allow 5432/tcp comment 'PostgreSQL'
    fi

    # >>>> Update allowed ports for Message  - RabbitMQ
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 5672 proto tcp comment 'RabbitMQ'
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 15672 proto tcp comment 'RabbitMQ - UI'
    else
      sudo ufw allow 5672/tcp comment 'RabbitMQ'
    fi

    # >>>> Update allowed ports for Server   - Nginx
    sudo ufw allow http  comment 'Nginx - HTTP'
    sudo ufw allow https comment 'Nginx - HTTPS'

    # >>>> Update allowed ports for Tools    - Remote Desktop
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      #sudo ufw allow 3389/tcp comment 'Remote Desktop'
      #sudo ufw allow from 192.168.0.0/24 to 192.168.0.0/24 port 3389 proto tcp comment 'Remote Desktop'
      echo
    fi

    # >>>> Update deny network
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      #sudo ufw deny from 10.0.0.0/8
      #sudo ufw deny from 172.16.0.0/12
      #sudo ufw deny from 192.168.0.0/16
      #sudo ufw deny from 192.168.0.0/24
      echo
    fi

    # ------------------------------------------------------------------------------------------------------------------
    # UFW - deny services                                                                              cat /etc/services
    # ------------------------------------------------------------------------------------------------------------------

    # Network services, Internet style

    sudo ufw deny tcpmux
    sudo ufw deny echo
    sudo ufw deny discard
    sudo ufw deny systat
    sudo ufw deny daytime
    sudo ufw deny netstat
    sudo ufw deny qotd
    sudo ufw deny chargen
    sudo ufw deny ftp-data
    sudo ufw deny ftp
    sudo ufw deny ssh
    sudo ufw deny telnet
    sudo ufw deny smtp
    sudo ufw deny time
    sudo ufw deny whois
    sudo ufw deny tacacs
    sudo ufw deny bootps
    sudo ufw deny bootpc
    sudo ufw deny tftp
    sudo ufw deny gopher
    sudo ufw deny finger
    sudo ufw deny kerberos
    sudo ufw deny iso-tsap
    sudo ufw deny acr-nema
    sudo ufw deny pop3
    sudo ufw deny sunrpc
    sudo ufw deny auth
    sudo ufw deny nntp
    sudo ufw deny epmap
    sudo ufw deny netbios-ns
    sudo ufw deny netbios-dgm
    sudo ufw deny netbios-ssn
    sudo ufw deny imap2
    sudo ufw deny snmp
    sudo ufw deny snmp-trap
    sudo ufw deny cmip-man
    sudo ufw deny cmip-agent
    sudo ufw deny mailq
    sudo ufw deny xdmcp
    sudo ufw deny bgp
    sudo ufw deny smux
    sudo ufw deny qmtp
    sudo ufw deny z3950
    sudo ufw deny ipx
    sudo ufw deny ptp-event
    sudo ufw deny ptp-general
    sudo ufw deny pawserv
    sudo ufw deny zserv
    sudo ufw deny rpc2portmap
    sudo ufw deny codaauth2
    sudo ufw deny clearcase
    sudo ufw deny ldap
    sudo ufw deny svrloc
    sudo ufw deny snpp
    sudo ufw deny microsoft-ds
    sudo ufw deny kpasswd
    sudo ufw deny submissions
    sudo ufw deny saft
    sudo ufw deny isakmp
    sudo ufw deny rtsp
    sudo ufw deny nqs
    sudo ufw deny asf-rmcp
    sudo ufw deny qmqp
    sudo ufw deny ipp
    sudo ufw deny ldp

    #
    # UNIX specific services
    #

    sudo ufw deny exec
    sudo ufw deny biff
    sudo ufw deny login
    sudo ufw deny who
    sudo ufw deny shell
    sudo ufw deny syslog
    sudo ufw deny printer
    sudo ufw deny talk
    sudo ufw deny ntalk
    sudo ufw deny route
    sudo ufw deny gdomap
    sudo ufw deny uucp
    sudo ufw deny klogin
    sudo ufw deny kshell
    sudo ufw deny dhcpv6-client
    sudo ufw deny dhcpv6-server
    sudo ufw deny afpovertcp
    sudo ufw deny nntps
    sudo ufw deny submission
    sudo ufw deny ldaps
    sudo ufw deny tinc
    sudo ufw deny silc
    sudo ufw deny kerberos-adm

    sudo ufw deny domain-s
    sudo ufw deny rsync
    sudo ufw deny ftps-data
    sudo ufw deny ftps
    sudo ufw deny telnets
    sudo ufw deny imaps
    sudo ufw deny pop3s

    #
    # From ``Assigned Numbers'':
    #

    sudo ufw deny socks
    sudo ufw deny proofd
    sudo ufw deny rootd
    sudo ufw deny openvpn
    sudo ufw deny rmiregistry
    sudo ufw deny lotusnote
    sudo ufw deny ms-sql-s
    sudo ufw deny ms-sql-m
    sudo ufw deny ingreslock
    sudo ufw deny datametrics
    sudo ufw deny sa-msg-port
    sudo ufw deny kermit
    sudo ufw deny groupwise
    sudo ufw deny l2f
    sudo ufw deny radius
    sudo ufw deny radius-acct
    sudo ufw deny cisco-sccp
    sudo ufw deny nfs
    sudo ufw deny gnunet
    sudo ufw deny rtcm-sc104
    sudo ufw deny gsigatekeeper
    sudo ufw deny gris
    sudo ufw deny cvspserver
    sudo ufw deny venus
    sudo ufw deny venus-se
    sudo ufw deny codasrv
    sudo ufw deny codasrv-se
    sudo ufw deny mon
    sudo ufw deny dict
    sudo ufw deny f5-globalsite
    sudo ufw deny gsiftp
    sudo ufw deny gpsd
    sudo ufw deny gds-db
    sudo ufw deny icpv2
    sudo ufw deny isns
    sudo ufw deny iscsi-target
    sudo ufw deny ms-wbt-server
    sudo ufw deny nut
    sudo ufw deny distcc
    sudo ufw deny daap
    sudo ufw deny svn
    sudo ufw deny suucp
    sudo ufw deny sysrqd
    sudo ufw deny sieve
    sudo ufw deny epmd
    sudo ufw deny remctl
    sudo ufw deny f5-iquery
    sudo ufw deny ntske
    sudo ufw deny ipsec-nat-t
    sudo ufw deny iax
    sudo ufw deny mtn
    sudo ufw deny radmin-port
    sudo ufw deny sip
    sudo ufw deny sip-tls
    sudo ufw deny xmpp-client
    sudo ufw deny xmpp-server
    sudo ufw deny cfengine
    sudo ufw deny mdns
    sudo ufw deny freeciv
    sudo ufw deny x11
    sudo ufw deny x11-1
    sudo ufw deny x11-2
    sudo ufw deny x11-3
    sudo ufw deny x11-4
    sudo ufw deny x11-5
    sudo ufw deny x11-6
    sudo ufw deny x11-7
    sudo ufw deny gnutella-svc
    sudo ufw deny gnutella-rtr
    sudo ufw deny sge-qmaster
    sudo ufw deny sge-execd
    sudo ufw deny mysql-proxy
    sudo ufw deny babel
    sudo ufw deny ircs-u
    sudo ufw deny bbs
    sudo ufw deny afs3-fileserver
    sudo ufw deny afs3-callback
    sudo ufw deny afs3-prserver
    sudo ufw deny afs3-vlserver
    sudo ufw deny afs3-kaserver
    sudo ufw deny afs3-volser
    sudo ufw deny afs3-bos
    sudo ufw deny afs3-update
    sudo ufw deny afs3-rmtsys
    sudo ufw deny font-service
    sudo ufw deny http-alt
    sudo ufw deny puppet
    sudo ufw deny bacula-dir
    sudo ufw deny bacula-fd
    sudo ufw deny bacula-sd
    sudo ufw deny xmms2
    sudo ufw deny nbd
    sudo ufw deny zabbix-agent
    sudo ufw deny zabbix-trapper
    sudo ufw deny amanda
    sudo ufw deny dicom
    sudo ufw deny hkp
    sudo ufw deny db-lsp
    sudo ufw deny dcap
    sudo ufw deny gsidcap
    sudo ufw deny wnn6

    # Kerberos (Project Athena/MIT) services

    sudo ufw deny kerberos4
    sudo ufw deny kerberos-master
    sudo ufw deny passwd-server
    sudo ufw deny krb-prop
    sudo ufw deny zephyr-srv
    sudo ufw deny zephyr-clt
    sudo ufw deny zephyr-hm
    sudo ufw deny iprop
    sudo ufw deny supfilesrv
    sudo ufw deny supfiledbg

    #
    # Services added for the Debian GNU/Linux distribution
    #

    sudo ufw deny poppassd
    sudo ufw deny moira-db
    sudo ufw deny moira-update
    sudo ufw deny moira-ureg
    sudo ufw deny spamd
    sudo ufw deny skkserv
    sudo ufw deny predict
    sudo ufw deny rmtcfg
    sudo ufw deny xtel
    sudo ufw deny xtelw
    sudo ufw deny zebrasrv
    sudo ufw deny zebra
    sudo ufw deny ripd
    sudo ufw deny ripngd
    sudo ufw deny ospfd
    sudo ufw deny bgpd
    sudo ufw deny ospf6d
    sudo ufw deny ospfapi
    sudo ufw deny isisd
    sudo ufw deny fax
    sudo ufw deny hylafax
    sudo ufw deny munin
    sudo ufw deny rplay
    sudo ufw deny nrpe
    sudo ufw deny nsca
    sudo ufw deny canna
    sudo ufw deny syslog-tls
    sudo ufw deny sane-port
    sudo ufw deny ircd
    sudo ufw deny zope-ftp
    sudo ufw deny tproxy
    sudo ufw deny omniorb
    sudo ufw deny clc-build-daemon
    sudo ufw deny xinetd
    sudo ufw deny git
    sudo ufw deny zope
    sudo ufw deny webmin
    sudo ufw deny kamanda
    sudo ufw deny amandaidx
    sudo ufw deny amidxtape
    sudo ufw deny sgi-cmsd
    sudo ufw deny sgi-crsd
    sudo ufw deny sgi-gcd
    sudo ufw deny sgi-cad
    sudo ufw deny binkp
    sudo ufw deny asp
    sudo ufw deny asp
    sudo ufw deny csync2
    sudo ufw deny dircproxy
    sudo ufw deny tfido
    sudo ufw deny fido

    # ------------------------------------------------------------------------------------------------------------------
    # UFW - Enable
    # ------------------------------------------------------------------------------------------------------------------
    echo
    sudo ufw disable
    sudo ufw enable
    echo

    sudo ufw status verbose
    echo
fi
