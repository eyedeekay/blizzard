FROM ubuntu:20.04
RUN apt update && apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    golang-go \
    make \
    git \
    build-essential \
    libssl-dev \
    g++ \
    markdown \
    libayatana-appindicator-dev \
    libayatana-appindicator3-dev \
    libgtk-3-dev \
    pkg-config
RUN addgroup --system --quiet --gid 1000 user
RUN adduser --disabled-password --gecos "" --uid 1000 --gid 1000 --shell /bin/bash --home /home/user user
COPY . /home/user/go/src/i2pgit.org/idk/blizzard
WORKDIR /home/user/go/src/i2pgit.org/idk/blizzard
RUN chown -R user:user /home/user
CMD make snowflake