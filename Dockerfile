FROM golang:1.25.5-alpine AS builder

WORKDIR /app

# Download dependencies first (better layer caching)
COPY go.mod go.sum ./
RUN go mod download && go mod verify

# Copy the rest of the sources
COPY . .

# Build the binary
RUN go build -o app ./main.go

# ---- Runtime image ----
FROM alpine:3.20

WORKDIR /app

# Install certs for outbound HTTPS (if the service needs it)
RUN apk add --no-cache ca-certificates

# Copy the compiled binary from the builder
COPY --from=builder /app/app /app/app
COPY --from=builder /app/app.conf.json /app/app.conf.json
# Copy static assets and templates needed at runtime
COPY --from=builder /app/views /app/views
COPY --from=builder /app/public /app/public

EXPOSE 8000
CMD ["./app"]