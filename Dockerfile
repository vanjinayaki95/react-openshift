# Build stage
FROM node:20 as build
WORKDIR /app
# Upgrade npm to latest recommended version
RUN npm install -g npm@11.3.0
COPY . .
RUN npm install && npm audit fix --force

RUN npm run build

# Serve with NGINX
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
