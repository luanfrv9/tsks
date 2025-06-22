FROM node:20
WORKDIR /app
COPY . .
RUN npm install
RUN npm run deploy
CMD ["node", ".output/index.js"]

