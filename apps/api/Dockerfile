FROM node:20-alpine AS deps

WORKDIR /app

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY apps/api/package.json apps/api/package.json

RUN corepack enable && corepack prepare pnpm@10.6.0 --activate
RUN pnpm install --frozen-lockfile --filter @couple-planet/api...

FROM deps AS build

WORKDIR /app

COPY apps/api apps/api
RUN pnpm --filter @couple-planet/api build

FROM node:20-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

COPY --from=build /app/apps/api/dist ./apps/api/dist
COPY --from=build /app/apps/api/package.json ./apps/api/package.json
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/apps/api/node_modules ./apps/api/node_modules

EXPOSE 3000

CMD ["node", "apps/api/dist/main.js"]
