FROM centos:centos7
MAINTAINER Mikkel Christiansen <mikkel@rheosystems.com>
RUN useradd --system --no-create-home bot
USER bot
COPY dist/build/h4h-bot /usr/local/bin/
WORKDIR /data/h4h-bot
COPY default.cfg bot.cfg
ENTRYPOINT ["h4h-bot"]
