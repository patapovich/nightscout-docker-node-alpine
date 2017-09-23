FROM mhart/alpine-node:8.5.0 AS builder

RUN apk --no-cache --update add git python make g++
RUN mkdir -p /opt/app

WORKDIR /opt/app
RUN git clone git://github.com/nightscout/cgm-remote-monitor.git /opt/app
RUN cd /opt/app && git checkout ${DEPLOY_HEAD-master}

RUN npm install && \
  npm run postinstall && \
  npm run env

FROM mhart/alpine-node:base-8.5.0
WORKDIR /opt/app
COPY --from=0 /opt/app .
COPY . .

EXPOSE 1337

CMD ["node", "server.js"]
