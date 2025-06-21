FROM node:20
WORKDIR /app
COPY . .
RUN npm install && npm run build
RUN npm install -g http-server
CMD ["http-server", "dist", "-p", "3001"]

