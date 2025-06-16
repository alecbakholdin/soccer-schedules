FROM node:18 AS build
WORKDIR /app
COPY package*.json .
COPY . .
RUN npm install
RUN npm run build

FROM node:18 AS run
ENV NODE_ENV=production
WORKDIR /app
COPY --from=build /app/build ./build
COPY --from=build /app/package.json ./package.json
COPY --from=build /app/node_modules ./node_modules
EXPOSE 3000
ENTRYPOINT ["node", "build"]
