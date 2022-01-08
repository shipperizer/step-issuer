# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM --platform=$BUILDPLATFORM golang:1.16 AS builder

LABEL org.opencontainers.image.source=https://github.com/shipperizer/step-issuer

ARG SKAFFOLD_GO_GCFLAGS
ARG TARGETOS
ARG TARGETARCH

ENV GOOS=$TARGETOS
ENV GOARCH=$TARGETARCH
ENV GO111MODULE=on
ENV CGO_ENABLED=0
RUN apt-get update

WORKDIR /var/app

COPY . .

RUN make build

FROM gcr.io/distroless/static:latest

LABEL org.opencontainers.image.source=https://github.com/shipperizer/step-issuer

COPY --from=builder /var/app/docker/bin/manager /manager

WORKDIR /
ENTRYPOINT ["/manager"]


# FROM gcr.io/distroless/static:latest
# ARG BINPATH="docker/bin/manager"
# COPY $BINPATH .
