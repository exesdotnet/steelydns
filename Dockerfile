FROM alpine:latest
ENV DNSCRYPT_VERSION 2.0.0
ENV CONF_FILE /config/dnscrypt-proxy.toml
RUN apk --no-cache add dnsmasq
COPY dnsmasq.conf /etc/dnsmasq.conf
COPY extra_hosts /config/extra_hosts
RUN apk add --no-cache wget ca-certificates
RUN wget -q https://github.com/jedisct1/dnscrypt-proxy/releases/download/$DNSCRYPT_VERSION/dnscrypt-proxy-linux_x86_64-$DNSCRYPT_VERSION.tar.gz
RUN tar -xzf dnscrypt-proxy-linux_x86_64-$DNSCRYPT_VERSION.tar.gz
RUN mkdir /opt/ /opt/dnscrypt-proxy
RUN mv /linux-x86_64/* /opt/dnscrypt-proxy
COPY dnscrypt-proxy.toml /config/dnscrypt-proxy.toml
RUN chown -R root:root /opt/dnscrypt-proxy
RUN chmod ugo+x /opt/dnscrypt-proxy/dnscrypt-proxy
RUN rm -R /linux-x86_64
EXPOSE 2053/tcp 2053/udp
VOLUME ["/config"]
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

