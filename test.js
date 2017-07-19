'use strict';

// const io = require('socket.io-client');
// const socket = io.connect('http://localhost:20133/');

// const Token = {'token' : '123gsdf'};
// socket.emit('authToken', JSON.stringify(Token));

// socket.on('newMessage', (data) => {
//     console.log(data);
// });

const mongo = require('mongodb').MongoClient
    , assert = require('assert');
const urlMongo = "mongodb://127.0.0.1:27017/chatDB";

mongo.connect(urlMongo, (err, db) => {
    assert.equal(null, err);
    db.collection('chatDB').update({login:'pavel'}, {$set:{online:true}});
});