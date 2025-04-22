# Build stage
FROM node:20-slim AS build
WORKDIR /app
COPY . .
ENV NODE_OPTIONS=--openssl-legacy-provider
# Upgrade npm to latest recommended version
RUN npm install && npm run build

# Serve with NGINX
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
