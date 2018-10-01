# run the dns node:
# docker run --name ccbc-seeder --restart=always -d --net bridge -p IP:53:53 -p IP:53:53/udp -v /seeder:/var/lib/ccbc-seeder  aviator86/ccbc-seeder
#
# and don't forget on the host:
#
#   ufw allow 53
#
# related resources:
#
#   https://github.com/sipa/bitcoin-seeder/blob/master/README
#   https://help.ubuntu.com/community/UFW
#   http://docs.docker.io/installation/ubuntulinux/#docker-and-ufw
FROM alpine:3.3

RUN mkdir -p /app/bin /app/src /var/lib/ccbc-seeder

WORKDIR /app/src

ADD . /app/src

RUN apk --no-cache add --virtual build_deps    \
      boost-dev                                \
      gcc                                      \
      git                                      \
      g++                                      \
      libc-dev                                 \
      make                                     \
      openssl-dev                           && \
      apk add --update bash                 && \
    make                                    && \
    make clean                              && \
    mv /app/src/dnsseed /app/bin/dnsseed    && \
    rm -rf /app/src                         && \
    apk --purge del build_deps              && \
    apk --no-cache add libgcc libstdc++

WORKDIR /var/lib/ccbc-seeder
VOLUME /var/lib/ccbc-seeder

EXPOSE 53/udp

ENTRYPOINT ["/app/bin/dnsseed"]

CMD ["-h", "dnsseed.ccbcoin.club", \
     "-n", "seed.ccbcoin.club", \
     "-m", "admin@ccbcoin.club", \
     "-p", "53"]