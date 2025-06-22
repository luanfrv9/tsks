FROM node:20
WORKDIR /app
COPY . .
RUN npx modern deploy
CMD ["node", ".output/index.js"]

