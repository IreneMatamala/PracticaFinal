FROM node:20-alpine as build
WORKDIR /app
COPY . .
RUN npm install --silent
FROM node:20-alpine
WORKDIR /app
COPY --from=build /app .
RUN npm install -g serve
EXPOSE 8080
CMD ["serve", "-s", ".", "-l", "8080"]
