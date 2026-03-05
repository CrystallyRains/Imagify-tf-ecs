#stage 1
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

#stage-2
FROM node:20-alpine AS runner

WORKDIR /app

#Copy the Standalone build 
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

EXPOSE 3000

CMD [ "node", "server.js" ]