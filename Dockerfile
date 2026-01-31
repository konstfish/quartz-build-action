ARG NODE_VERSION=22
FROM node:${NODE_VERSION}-alpine

RUN apk add --no-cache git coreutils

WORKDIR /quartz

COPY --chmod=755 entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
