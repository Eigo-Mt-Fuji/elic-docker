FROM erlang:21-slim

LABEL maintainer="efg.river@gmail.com" \
      version="0.1" \
      description="elic docker image consists of elixir, nodejs, phoenix builder."

# RUN mkdir -p /usr/local/src/elixir
# RUN mkdir -p /usr/local/lib/elixir
# RUN useradd -rm -d /home/elic -s /bin/bash -g root elic
# RUN chown -R elic /usr/local/src/elixir && chmod -R 755 /usr/local/src/elixir
# RUN chown -R elic /usr/local/lib/elixir && chmod -R 755 /usr/local/lib/elixir
# RUN chown -R elic /usr/local/bin/
# RUN chown -R elic /usr/local/share/man

# USER elic
# WORKDIR /home/elic

# specify versions, elixir expects utf8 in specific.
ENV ELIXIR_VERSION="v1.8.1" \
    PHOENIX_VERSION="1.4.1" \
    NODE_MAJOR_VERSION="10" \
    LANG=C.UTF-8

# specify debconf no-warning  (see: http://manpages.ubuntu.com/manpages/xenial/man7/debconf.7.html)
ENV DEBCONF_NOWARNINGS=yes

RUN apt-get update
RUN apt-get -y install curl
RUN apt-get -y install make
RUN apt-get -y install gnupg
RUN apt-get install -y apt-transport-https
RUN set -xe \
  && ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
  && ELIXIR_DOWNLOAD_SHA256="de8c636ea999392496ccd9a204ccccbc8cb7f417d948fd12692cda2bd02d9822" \
  && curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL \
  && echo "$ELIXIR_DOWNLOAD_SHA256  elixir-src.tar.gz" | sha256sum -c - \
  && mkdir -p /usr/local/src/elixir \
  && tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
  && rm elixir-src.tar.gz && cd /usr/local/src/elixir && make install clean

RUN mix local.hex --force phx_new $PHOENIX_VERSION
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=TRUE
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN cat /etc/os-release
RUN curl -sL https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash -

CMD ["iex"]

