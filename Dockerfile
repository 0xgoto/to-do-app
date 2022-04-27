FROM node:16.13.2-alpine

WORKDIR /usr/app


COPY package.json .
COPY yarn.lock .
RUN yarn install

COPY . .
ENTRYPOINT yarn start