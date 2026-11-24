FROM rust:1-alpine AS builder
RUN apk --no-cache add musl-dev
RUN rustup target add wasm32-unknown-unknown
RUN cargo install wasm-pack --version 0.13.1 --locked
WORKDIR /app
COPY . .
RUN wasm-pack build room --target web --out-dir ../web/pkg --release --no-opt

FROM python:3-alpine
WORKDIR /srv
COPY --from=builder /app/web /srv/web
EXPOSE 8000
USER 1000
CMD ["python3", "-m", "http.server", "8000", "--directory", "web"]
