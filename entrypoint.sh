#!/bin/sh

mkdir -p /config
if [ ! -f /config/dnscrypt-proxy.toml ]; then
    cp /opt/dnscrypt-proxy/example-dnscrypt-proxy.toml /config/dnscrypt-proxy.toml
fi

#exec "$@"

#echo "server=$(getent hosts steelydns | cut -d' ' -f1)#2053" >> /etc/dnsmasq.conf

/usr/sbin/dnsmasq -C /etc/dnsmasq.conf # --keep-in-foreground --log-facility=- -q
/opt/dnscrypt-proxy/dnscrypt-proxy -syslog -config /config/dnscrypt-proxy.toml

