FROM golang:alpine as build

WORKDIR /go/src/github.com/gliderlabs/logspout
RUN set -x \
    && apk add --update git mercurial build-base ca-certificates

RUN set -x \
    && git clone --recursive https://github.com/gliderlabs/logspout.git /go/src/github.com/gliderlabs/logspout \
    && git checkout v3.2.4

RUN set -x \
    && echo 'import _ "github.com/looplab/logspout-logstash"' >> /go/src/github.com/gliderlabs/logspout/modules.go

RUN set -x \
    && go get

RUN set -x \
    && go build -ldflags "-X main.Version=$1" -o /bin/logspout
   
FROM alpine
RUN set -x \
    && apk add --update ca-certificates
COPY --from=build /bin/logspout /bin/logspout
CMD ["/bin/logspout"]
