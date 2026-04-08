const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const Docker = require('dockerode');

const app = express();
const server = http.createServer(app);
const io = new Server(server);
const docker = new Docker({ socketPath: '/var/run/docker.sock' });

app.get('/', (req, res) => {
    res.send('<h1>NanoClaw Dashboard kjører!</h1><p>Koble til med agenten for å se statistikk.</p>');
});

io.on('connection', (socket) => {
    console.log('Agent tilkoblet:', socket.id);
    
    socket.on('stats', (data) => {
        console.log('Stats mottatt:', data);
    });
});

const PORT = process.env.PORT || 80;
server.listen(PORT, () => {
    console.log(`NanoClaw server kjører på port ${PORT}`);
});
