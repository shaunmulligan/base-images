FROM resin/i386-debian:wheezy

COPY entry.sh /usr/bin/entry.sh

ENV RESIN_STOP_SIGNAL SIGRTMIN+3
STOPSIGNAL 37

ENTRYPOINT ["/usr/bin/entry.sh"]
