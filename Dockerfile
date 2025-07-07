FROM ghcr.io/gohugoio/hugo:latest AS build

ARG ENVIRONMENT=main

ADD --chown=hugo:hugo . . 

RUN hugo --minify --environment $ENVIRONMENT

FROM lipanski/docker-static-website:latest

ADD httpd.conf .

COPY --from=build /project/public .
