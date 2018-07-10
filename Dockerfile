FROM golang:1.10-alpine as builder

COPY . /go/src/github.com/storj/netlify-cms-oauth-provider-go

RUN apk -U add gcc musl-dev

RUN go build -a -ldflags "-linkmode external -extldflags \"-static\" -s -w" \
    -o /app \
    github.com/storj/netlify-cms-oauth-provider-go

FROM scratch
EXPOSE 3000
ENTRYPOINT ["/app"]
ENV HOST=127.0.0.1:3000 \
    BINDENV=0.0.0.0:3000 \
    GITHUB_KEY= \
    GITHUB_SECRET= \
    BITBUCKET_KEY= \
    BITBUCKET_SECRET= \
    GITLAB_KEY= \
    GITLAB_SECRET= \
    SESSION_SECRET=
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

COPY --from=builder /app /app
