FROM erlang:21-slim

LABEL maintainer="efg.river@gmail.com" \
      version="0.1" \
      description="elic docker image consists of elixir, nodejs, phoenix builder."

# specify versions, elixir expects utf8 in specific.
ENV ELIXIR_VERSION="v1.9.4" \
    PHOENIX_VERSION="1.4.1" \
    NODE_MAJOR_VERSION="12" \
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
  && ELIXIR_DOWNLOAD_SHA512="c97b93c7438efd7215408525a3b9f2935a1591cce3da3eb31717282d06aff94e8e3d22c405bac40c671bcfe8e73f3dd1ada315f53dee73ceef0bfe2a7c27e86d" \
  && curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL \
  && echo "$ELIXIR_DOWNLOAD_SHA512  elixir-src.tar.gz" | sha512sum -c - \
  && mkdir -p /usr/local/src/elixir \
  && tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
  && rm elixir-src.tar.gz && cd /usr/local/src/elixir && make install clean

RUN mix local.hex --force phx_new $PHOENIX_VERSION
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=TRUE
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN cat /etc/os-release
RUN curl -sL https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash -
RUN apt-get -y install nodejs yarn
RUN apt-get install -y inotify-tools
RUN mix local.hex --force
RUN mix local.rebar --force

CMD ["iex"]

