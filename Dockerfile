FROM rust:1-alpine AS builder
RUN apk --no-cache add musl-dev
WORKDIR /app
COPY . .
RUN cargo build --release

FROM alpine:3.24
RUN apk --no-cache upgrade
RUN apk --no-cache add ca-certificates
COPY --from=builder /app/target/release/app /usr/local/bin/app
EXPOSE 8080
USER 1000
CMD ["app"]
