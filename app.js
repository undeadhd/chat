'use strict';

const logger = require('log4js').getLogger();
const io = require('socket.io').listen(20133);
logger.info('запуск');
const mongo = require('mongodb').MongoClient
    , assert = require('assert');
const urlMongo = 'mongodb://127.0.0.1:27017/chatDB';


io.on('connection', (socket) => {
    logger.debug('connected -> ' + socket.id.toString());
    
    socket.emit('hardAuth');

    socket.on('authToken', (data) => {
        authTokenSocket(data, socket);
    });

    socket.on('messageFor', (data) => {
        messageFor(socket, data);
    });

    socket.on('disconnect', (data) => {
        disconnect(socket);
    });

});

function disconnect(socket) {
    mongo.connect(urlMongo, (err, db) => {
        db.collection('chatDB').update({socket_id:socket.id.toString()}, {$set:{online:false, socket_id: ''}});
        socket.disconnect(true);
        logger.info('socket ' + socket.id.toString() + ' is disconnect');
        db.close();
    });
}


function messageFor(socket, json) {
    //json = JSON.parse(json);
    console.log(json);
    mongo.connect(urlMongo, (err, db) => {
        assert.equal(null, err);
        db.collection('chatDB').find({token: json.token}).toArray((err, results) => {
            if (results.length === 0) {
                socket.emit('badToken', JSON.stringify('bad token'));
            } else {
                mongo.connect(urlMongo, (err, db) => {
                    assert.equal(null, err);
                    db.collection('chatDB').find({user_id: json.ForID}).toArray((err, results) => {
                        if (results.length === 0) {
                            socket.emit('noUser', JSON.stringify('noUser'));
                        } else {
                            const sock_id = results[0]['socket_id'];
                            logger.debug('Отправляем адресату ' + sock_id);
                            const sendData = JSON.stringify({"text": json.text, "senderID": json.myID});
                            socket.to(json.ForID).emit('newMessage', sendData);
                        }
                    });
                });
            }
        });
        db.close();
    });
}


function authTokenSocket(data, socket) {
    console.log(data);
    //data = JSON.parse(data);
    mongo.connect(urlMongo, function(err, db) {
        assert.equal(null, err);
        console.log('connected to MongoDB succes');
        db.collection('chatDB').find({token: data.token}).toArray((err, results) => {
            db.close();
            mongo.connect(urlMongo, (err, db) => {
                if (results.length > 0) {
                    if (results[0]['token'] === data.token) {
                        db.collection('chatDB').update({user_id:results[0]['user_id']}, {$set:{socket_id:socket.id.toString()}});
                        db.collection('chatDB').update({token:results[0]['token']}, {$set:{online:true}});
                        //socket.join(results[0]['user_id']);
                        socket.join(results[0]['user_id']);
                    } else {
                        socket.emit('badToken', JSON.stringify('bad token'));
                    }
                } else {
                    socket.emit('badToken', JSON.stringify('bad token'));
                }
                db.close();
            });
        });
    });
}