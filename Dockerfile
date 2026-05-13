FROM ghcr.io/cirruslabs/flutter:3.41.5 AS api_build

WORKDIR /app
COPY server/ api_server/
RUN cd api_server && dart pub get && \
    dart compile exe -o api_server --target-os linux bin/server.dart

FROM ghcr.io/cirruslabs/flutter:3.41.5 AS web_build

WORKDIR /app
COPY client/ web_client/
RUN cd web_client && flutter pub get && flutter build web --release

FROM nginx:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

COPY --from=api_build /app/api_server/api_server /opt/api_server/api_server
COPY --from=web_build /app/web_client/build/web/ /usr/share/nginx/html/
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV DATA_PATH=/var/opt/api_server
ARG ENVIRONMENT=localhost
ENV ENVIRONMENT=${ENVIRONMENT}
RUN echo "$ENVIRONMENT"

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
