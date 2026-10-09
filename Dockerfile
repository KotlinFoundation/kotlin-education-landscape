# Build the TanStack Start dashboard
FROM node:20-alpine AS build
WORKDIR /app
COPY dashboard/package.json dashboard/package-lock.json ./
RUN npm ci --legacy-peer-deps
COPY dashboard/ ./
RUN npm run build

# Runtime: Nitro node-server output is self-contained
FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production \
    HOST=0.0.0.0 \
    PORT=8080
COPY --from=build /app/.output ./.output
USER 1000:1000
EXPOSE 8080
CMD ["node", ".output/server/index.mjs"]
