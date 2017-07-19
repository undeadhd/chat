'use strict';

const io = require('socket.io-client');
const tokenGenerator = require('uuid-token-generator');
const socket = io.connect('http://localhost:20133/');

const jsonToken = {'token' : '123gsdf', 'myID':213, 'ForID': 123, 'text':'привет'};
const json = {'token':'123gsdf'};
socket.emit('authToken', JSON.stringify(json));

socket.on('newMessage', (data) => {
    console.log(data);
});

socket.on('con', (data) => {
    console.log(data);
});

socket.emit('messageFor', JSON.stringify(jsonToken));
//socket.disconnect();

// const mongo = require('mongodb').MongoClient
//     , assert = require('assert');
// const urlMongo = 'mongodb://127.0.0.1:27017/chatDB';

// //mongo.set('debug', true);
// mongo.connect(urlMongo, function(err, db) {
//     assert.equal(null, err);
//     db.collection('chatDB').find({login: 'pavel'}).toArray((err, results) => {
//         const token = new tokenGenerator(256, tokenGenerator.BASE62);
//         const newToken = token.generate();
//         console.log(newToken);
//     })
// });