# Eksempel for Node.js (juster til ditt faktiske miljø)
FROM node:20-slim

WORKDIR /app

COPY package*.json ./
RUN npm install --production

COPY . .

EXPOSE 80

CMD ["npm", "start"]
