# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0

# Dynatrace Support limited to official, stable Go releases - https://docs.dynatrace.com/docs/ingest-from/technology-support/application-software/go/support/go-known-limitations#go-official-stable-releases
FROM golang:1.22.10-alpine AS builder

WORKDIR /usr/src/app/

RUN --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=bind,source=./src/checkoutservice/go.sum,target=go.sum \
    --mount=type=bind,source=./src/checkoutservice/go.mod,target=go.mod \
    go mod download

# Applications built with -buildmode=pie option and CGO disabled aren't supported by Dynatrace - https://docs.dynatrace.com/docs/ingest-from/technology-support/application-software/go/support/go-known-limitations#applications-built-with-buildmodepie-option-and-cgo-disabled-arent-supported
RUN --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=bind,rw,source=./src/checkoutservice,target=. \
    CGO_ENABLED=0 go build -o /go/bin/checkoutservice/ ./ 

FROM alpine

WORKDIR /usr/src/app/

COPY --from=builder /go/bin/checkoutservice/ ./

EXPOSE ${CHECKOUT_SERVICE_PORT}
# Dynatrace Support for statically linked binaries - https://docs.dynatrace.com/docs/ingest-from/technology-support/application-software/go/support/go-known-limitations#static-monitoring
ENTRYPOINT ["/bin/sh", "-c", "'./checkoutservice'"]
