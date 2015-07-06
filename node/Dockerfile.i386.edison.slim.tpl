# AUTOGENERATED FILE
FROM #{FROM}

ENV NODE_VERSION #{NODE_VERSION}
ENV NPM_VERSION 2.10.1

RUN apt-get update && apt-get install -y curl --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -SLO "#{BINARY_URL}" \
	&& tar -xzf "node-v$NODE_VERSION-linux-#{TARGET_ARCH}.tar.gz" -C /usr/local --strip-components=1 \
	&& rm "node-v$NODE_VERSION-linux-#{TARGET_ARCH}.tar.gz" \
	&& apt-get purge -y --auto-remove curl \
	&& npm install -g npm@"$NPM_VERSION" --unsafe-perm \
	&& npm install mraa \
	&& npm cache clear \
	&& rm -rf /tmp/*

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/#/pages/using/dockerfile.md"]
