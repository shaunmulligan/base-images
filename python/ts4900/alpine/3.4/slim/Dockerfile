FROM resin/ts4900-alpine:latest

# remove several traces of python
RUN apk del python*

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# install python dependencies
RUN apk add --no-cache \
		sqlite-libs \
		libssl1.0

# import gpg keys
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 97FC712E4C024BBEA48A61ED3A5CA953F73C700D

# key 63C7CC90: public key "Simon McVittie <smcv@pseudorandom.co.uk>" imported
RUN gpg --keyserver keyring.debian.org --recv-keys 4DE8FF2A63C7CC90

# key 3372DCFA: public key "Donald Stufft (dstufft) <donald@stufft.io>" imported
RUN gpg --keyserver pgp.mit.edu  --recv-key 6E3CBCE93372DCFA

ENV PYTHON_VERSION 3.4.4

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 8.0.3

ENV SETUPTOOLS_SHA256 24fcfc15364a9fe09a220f37d2dcedc849795e3de3e4b393ee988e66a9cbd85a
ENV SETUPTOOLS_VERSION 20.2.2

RUN set -x \
	&& buildDeps=' \
		curl \
		gcc \
		libbz2 \
		musl-dev \
		ncurses5-libs \
		readline-dev \
		sqlite-dev \
		openssl-dev \
		make \
		xz \
		zlib-dev \
	' \
	&& apk add --no-cache --virtual .build-deps $buildDeps \
	&& mkdir -p /usr/src/python \
	&& curl -SL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" -o python.tar.xz \
	&& curl -SL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" -o python.tar.xz.asc \
	&& gpg --verify python.tar.xz.asc \
	&& tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
	&& rm python.tar.xz* \
	&& cd /usr/src/python \
	&& ./configure --enable-shared --enable-unicode=ucs4 \
	&& make -j$(nproc) \
	&& make install \
	&& mkdir -p /usr/src/python/setuptools \
	&& curl -SLO https://pypi.python.org/packages/source/s/setuptools/setuptools-$SETUPTOOLS_VERSION.tar.gz \
	&& echo "$SETUPTOOLS_SHA256  setuptools-$SETUPTOOLS_VERSION.tar.gz" > setuptools-$SETUPTOOLS_VERSION.tar.gz.sha256sum \
	&& sha256sum -c setuptools-$SETUPTOOLS_VERSION.tar.gz.sha256sum \
	&& tar -xzC /usr/src/python/setuptools --strip-components=1 -f setuptools-$SETUPTOOLS_VERSION.tar.gz \
	&& cd /usr/src/python/setuptools \
	&& python3 ez_setup.py \
	&& mkdir -p /usr/src/python/pip \
	&& curl -SL "https://pypi.python.org/packages/source/p/pip/pip-$PYTHON_PIP_VERSION.tar.gz" -o pip.tar.gz \
	&& curl -SL "https://pypi.python.org/packages/source/p/pip/pip-$PYTHON_PIP_VERSION.tar.gz.asc" -o pip.tar.gz.asc \
	&& gpg --verify pip.tar.gz.asc \
	&& tar -xzC /usr/src/python/pip --strip-components=1 -f pip.tar.gz \
	&& rm pip.tar.gz* \
	&& cd /usr/src/python/pip \
	&& python3 setup.py install \
	&& cd .. \
	&& find /usr/local \
		\( -type d -a -name test -o -name tests \) \
		-o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
		-exec rm -rf '{}' + \
	&& cd / \
	&& apk del .build-deps \
	&& rm -rf /usr/src/python

# install "virtualenv", since the vast majority of users of this image will want it
RUN pip3 install --no-cache-dir virtualenv

# install dbus-python dependencies
RUN apk add --no-cache \
		dbus-dev \
		dbus-glib-dev

ENV PYTHON_DBUS_VERSION 1.2.0

# install dbus-python
RUN set -x \
	&& buildDeps=' \
		curl \
		build-base \
	' \
	&& apk add --no-cache --virtual .build-deps $buildDeps \
	&& mkdir -p /usr/src/dbus-python \
	&& curl -SL "http://dbus.freedesktop.org/releases/dbus-python/dbus-python-$PYTHON_DBUS_VERSION.tar.gz" -o dbus-python.tar.gz \
	&& curl -SL "http://dbus.freedesktop.org/releases/dbus-python/dbus-python-$PYTHON_DBUS_VERSION.tar.gz.asc" -o dbus-python.tar.gz.asc \
	&& gpg --verify dbus-python.tar.gz.asc \
	&& tar -xzC /usr/src/dbus-python --strip-components=1 -f dbus-python.tar.gz \
	&& rm dbus-python.tar.gz* \
	&& cd /usr/src/dbus-python \
	&& PYTHON=python3.4 ./configure \
	&& make \
	&& make install \
	&& cd / \
	&& apk del .build-deps \
	&& rm -rf /usr/src/dbus-python

# make some useful symlinks that are expected to exist
RUN cd /usr/local/bin \
	&& ln -sf pip3 pip \
	&& ln -sf easy_install-3.4 easy_install \
	&& ln -sf idle3 idle \
	&& ln -sf pydoc3 pydoc \
	&& ln -sf python3 python \
	&& ln -sf python-config3 python-config

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/#/pages/using/dockerfile.md"]
ENV PYTHONPATH /usr/lib/python3/dist-packages
