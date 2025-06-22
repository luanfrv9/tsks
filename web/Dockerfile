FROM node:20
WORKDIR /app
COPY . .
RUN npm install
RUN npm run deploy
CMD ["npm", "run", "serve"]

