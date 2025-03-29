#Etap 1
FROM alpine AS builder
ARG VERSION="1.0.0"

RUN mkdir -p /app

RUN echo "<html><head><title>Aplikacja Web</title></head><body>" > /app/index.template.html && \
    echo "<h1>Aplikacja Web</h1>" >> /app/index.template.html && \
    echo "<p><strong>IP serwera:</strong> \$HOST</p>" >> /app/index.template.html && \
    echo "<p><strong>Nazwa hosta:</strong> \$HOSTNAME</p>" >> /app/index.template.html && \
    echo "<p><strong>Wersja aplikacji:</strong> $VERSION</p>" >> /app/index.template.html && \
    echo "</body></html>" >> /app/index.template.html

#Etap 2
FROM nginx:alpine

RUN apk add --no-cache bash curl gettext

COPY --from=builder /app/index.template.html /usr/share/nginx/html/index.template.html

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost || exit 1
    