FROM alpine:3.7

RUN apk add --update \
        bash \
        util-linux \
        coreutils \
        binutils \
        findutils \
        grep \
        perl \
        git \
        && rm -rf /var/cache/apk/*

WORKDIR /usr/src/app

# provide $WORKDIR to the plugin because drone changes the default WORKDIR
ENV WORKDIR=/usr/src/app

# install plugin
COPY main.sh plugin.sh ./

# run plugin
ENTRYPOINT ["/usr/src/app/main.sh"]
