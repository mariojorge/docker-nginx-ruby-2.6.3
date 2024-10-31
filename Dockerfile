# Etapa 1: Builder para construir a aplicação Rails
FROM ruby:2.6.3-slim

# Instalar dependências para compilar o Passenger
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  gnupg \
  gnupg2 \
  dirmngr \
  apt-transport-https \
  ca-certificates \
  libpq-dev \
  imagemagick \
  libmagickwand-dev \
  wget \
  curl \
  zlib1g-dev \
  libcurl4-openssl-dev \
  nginx \
  nano \
  cron \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
  #gcc \
  #make \

RUN wget http://archive.ubuntu.com/ubuntu/pool/main/libj/libjpeg-turbo/libjpeg-turbo8_2.0.3-0ubuntu1_amd64.deb && dpkg -i libjpeg-turbo8_2.0.3-0ubuntu1_amd64.deb

# Instalar Node.js e Yarn
SHELL ["/bin/bash", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash && \
  source /root/.nvm/nvm.sh && \
  nvm install 14 && \
  npm install --global yarn && \
  ln -s /root/.nvm/versions/node/v14.*/bin/yarn /usr/local/bin/yarn && \
  ln -s /root/.nvm/versions/node/v14.*/bin/node /usr/local/bin/node

# Adicionar o repositório do Phusion Passenger
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 \
  && sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger buster main > /etc/apt/sources.list.d/passenger.list' \
  && apt-get update && apt-get install -y --no-install-recommends libnginx-mod-http-passenger \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*