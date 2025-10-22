FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build || echo "No build step, using static files"

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html 2>/dev/null || \
    cp -r /app/* /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
