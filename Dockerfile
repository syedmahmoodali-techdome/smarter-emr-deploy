FROM node:20 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --legacy-peer-deps
COPY . .
RUN npm run build

FROM node:20-slim AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app ./
# Use a predictable port for Azure Web App container
ENV PORT=8080
EXPOSE 8080
# Start the Next.js production server (no repo code changes required)
CMD ["npx","next","start","-p","8080"]
