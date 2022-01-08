# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM --platform=$BUILDPLATFORM golang:1.16 AS builder

LABEL org.opencontainers.image.source=https://github.com/shipperizer/step-issuer

ARG SKAFFOLD_GO_GCFLAGS
ARG TARGETOS
ARG TARGETARCH

ENV GOOS=$TARGETOS
ENV GOARCH=$TARGETARCH
ENV CGO_ENABLED=0
RUN apt-get update

WORKDIR /var/app

COPY . .

RUN V=1 PREFIX=/var/app make -j 1 generate
RUN V=1 make bin/manager

FROM gcr.io/distroless/static:latest

LABEL org.opencontainers.image.source=https://github.com/shipperizer/step-issuer

COPY --from=builder /var/app/bin/manager /manager

WORKDIR /
ENTRYPOINT ["/manager"]
