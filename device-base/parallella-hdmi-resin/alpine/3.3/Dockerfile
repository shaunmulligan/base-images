FROM resin/armhf-alpine:3.3

LABEL io.resin.device-type="parallella-hdmi-resin"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \		
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*
