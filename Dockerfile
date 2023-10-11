FROM node:18-alpine As builder
# Create app directory
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . ./
RUN npm run prisma:generate:dev
RUN npm run build

# Only Production Dependencies
FROM node:18-alpine As deps
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

# Production image
FROM node:18-alpine As production
WORKDIR /usr/src/app
COPY --chown=node:node --from=builder /usr/src/app/dist ./dist
COPY --chown=node:node --from=builder /usr/src/app/.env .env
COPY --chown=node:node --from=builder /usr/src/app/package.json .
COPY --chown=node:node --from=deps /usr/src/app/node_modules/ ./node_modules/
COPY --chown=node:node --from=builder /usr/src/app/prisma ./prisma/
COPY --chown=node:node --from=builder /usr/src/app/tsconfig.json .
# Running as Non-Root User
USER node
# Starting Server
EXPOSE 3333
CMD [ "node", "dist/src/main.js"]