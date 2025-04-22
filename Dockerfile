# Build stage
FROM node:20-slim AS build
WORKDIR /app
COPY . .
ENV NODE_OPTIONS=--openssl-legacy-provider
# Upgrade npm to latest recommended version
RUN npm install && npm run build

# Serve with NGINX
FROM nginx:alpine
RUN rm /etc/nginx/conf.d/default.conf

# Copy your custom config
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/build /usr/share/nginx/html
RUN mkdir -p /var/cache/nginx/client_temp && \
    chmod -R 777 /var/cache/nginx
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
