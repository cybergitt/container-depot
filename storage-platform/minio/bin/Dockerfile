# =========================
# Build Stage
# =========================
FROM golang:alpine3.23 AS builder

ARG RELEASE=RELEASE.2025-09-07T16-13-09Z

# Security & reproducibility
RUN apk add --no-cache git bash ca-certificates build-base

WORKDIR /build

# Build MinIO from source
RUN git clone https://github.com/minio/minio.git . \
    && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
       go build -trimpath -ldflags="-s -w" -o minio

# =========================
# Runtime Stage
# =========================
FROM alpine:3.23

#RUN apk add --no-cache ca-certificates && \
#    addgroup -S minio -g 1000 && adduser -S minio -u 1000 -G minio
#RUN apk add --no-cache ca-certificates

# Install minimal runtime deps
RUN apk add --no-cache ca-certificates curl tzdata \
    && addgroup -S minio \
    && adduser -S minio -G minio

# Set timezone
ENV TZ="Asia/Jakarta"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# MinIO directories
ENV MINIO_HOME=/opt/minio
ENV MINIO_DATA=/data

RUN mkdir -p ${MINIO_HOME} ${MINIO_DATA} \
    && chown -R minio:minio ${MINIO_HOME} ${MINIO_DATA}

WORKDIR ${MINIO_HOME}

# Copy binary
COPY --from=builder /build/minio /usr/local/bin/minio

# Drop privileges
USER minio

# Expose API & Console
EXPOSE 9000 9001

# Healthcheck (non-root safe)
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s \
  CMD curl -f http://localhost:9000/minio/health/live || exit 1

ENTRYPOINT ["minio"]
CMD ["server", "/data", "--console-address", ":9001"]