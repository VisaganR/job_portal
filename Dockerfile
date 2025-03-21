FROM node:18-alpine as builder
RUN apk add --no-cache build-base cairo-dev pango-dev jpeg-dev giflib-dev
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --include=dev
COPY . .

RUN npm run build

FROM node:18-alpine AS runner
WORKDIR /app
COPY --from=builder /app/.next/standalone .
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/static ./.next/static

EXPOSE 3000
CMD ["node", "server.js"]