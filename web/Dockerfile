FROM node:20
WORKDIR /app
COPY . .
RUN npm run deploy
CMD ["node", ".output/index.js"]

