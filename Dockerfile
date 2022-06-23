ARG RELEASE_TAG=development
FROM node:18-alpine AS builder

ARG RELEASE_TAG

RUN mkdir /build
WORKDIR /build

RUN git clone --branch ${RELEASE_TAG} --single-branch --depth 1 https://github.com/litesolutions/justifay-stream-api

WORKDIR /build/justifay-stream-api

RUN npm i -g npm
RUN npm install
RUN npm run build

FROM node:18-alpine

WORKDIR /build/justifay-stream-api

COPY --from=builder /build/justifay-stream-api/.env.example ./
COPY --from=builder /build/justifay-stream-api/package* ./
COPY --from=builder /build/justifay-stream-api/node_modules ./node_modules
COPY --from=builder /build/justifay-stream-api/lib ./lib

EXPOSE 4000

CMD ["npm", "start"]
