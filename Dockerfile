ARG NODE_VERSION=20
FROM node:${NODE_VERSION}-alpine

RUN apk add --no-cache git \
    && git clone --depth 1 https://github.com/jackyzha0/quartz.git /quartz \
    && cd /quartz \
    && mkdir -p content \
    && npm ci --only=production \
    && npx quartz create -X new -l shortest

WORKDIR /quartz

COPY --chmod=755 entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]