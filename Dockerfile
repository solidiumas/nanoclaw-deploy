FROM node:20

WORKDIR /app

RUN apt-get update && apt-get install -y git

# Clone NanoClaw directly inside container
RUN git clone https://github.com/qwibitai/nanoclaw.git .

# Install dependencies
RUN npm install

# Build agent container (CRITICAL)
RUN cd container && docker build -t nanoclaw-agent:latest .

EXPOSE 3000

CMD ["npm", "start"]
