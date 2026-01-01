# 2026-01-01 20:14:20 by RouterOS 7.16.2
# software id = ZJ3M-ESHW
#
/interface ethernet
set [ find default-name=ether2 ] mac-address=00:0C:29:6E:1A:FC name=ether1
set [ find default-name=ether1 ] disable-running-check=no name=ether2
/disk
set primary-slave media-interface=none media-sharing=no slot=primary-slave
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip ipsec profile
set [ find default=yes ] dpd-interval=2m dpd-maximum-failures=5
add dh-group=modp2048 enc-algorithm=aes-256 hash-algorithm=sha256 lifetime=1h \
    name=profile1 prf-algorithm=sha256
/ip ipsec peer
# IKEv1 does not support prf selection!
add address=192.168.2.200/32 name=peer1 profile=profile1
/ip ipsec proposal
set [ find default=yes ] enc-algorithms=aes-128-cbc,3des
add auth-algorithms=sha256,sha1 lifetime=1h name=proposal1 pfs-group=none
/ip pool
add name=dhcp_pool0 ranges=10.0.0.2-10.0.3.254
/ip hotspot
add address-pool=dhcp_pool0 disabled=no interface=ether2 name=server1
/port
set 0 name=serial0
set 1 name=serial1
/queue interface
set ether1 queue=ethernet-default
/snmp community
set [ find default=yes ] addresses=0.0.0.0/0
/ip firewall connection tracking
set udp-timeout=10s
/ip settings
set max-neighbor-entries=14336
/ipv6 settings
set max-neighbor-entries=7168
/ip address
add address=192.168.2.10/24 interface=ether1 network=192.168.2.0
add address=10.0.0.1/22 interface=ether2 network=10.0.0.0
/ip dhcp-server
add address-pool=dhcp_pool0 interface=ether2 name=dhcp1
/ip dhcp-server network
add address=10.0.0.0/22 gateway=10.0.0.1
/ip dns
set servers=8.8.8.8
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=accept chain=input protocol=ipsec-esp
add action=accept chain=input dst-port=4500 protocol=udp
add action=accept chain=input dst-port=500 protocol=udp
add action=drop chain=forward dst-address=1.1.1.1 dst-port=443 protocol=tcp \
    src-address=0.0.0.0/0
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat dst-address=12.0.0.0 src-address=11.0.0.0
add action=masquerade chain=srcnat dst-address=11.0.0.0 src-address=12.0.0.0
add action=accept chain=srcnat disabled=yes dst-address=192.168.1.0/24 \
    src-address=192.168.2.0/24
/ip ipsec identity
add peer=peer1
/ip ipsec policy
set 0 disabled=yes dst-address=0.0.0.0/0 src-address=0.0.0.0/0
add disabled=yes dst-address=192.168.1.0/24 src-address=192.168.2.0/24 \
    tunnel=yes
add dst-address=11.0.0.0/32 peer=peer1 proposal=proposal1 src-address=\
    12.0.0.0/32 tunnel=yes
/ip route
add disabled=no dst-address=0.0.0.0/0 gateway=192.168.2.1
add disabled=no dst-address=192.168.1.0/24 gateway=*2
/ipv6 nd
set [ find default=yes ] advertise-dns=no
/radius
add address=192.168.2.10 service=hotspot
/routing bfd configuration
add disabled=no interfaces=all min-rx=200ms min-tx=200ms multiplier=5
/system clock
set time-zone-autodetect=no
/system identity
set name=ssplash-networks
/system note
set show-at-login=no
