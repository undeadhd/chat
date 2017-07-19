'use strict';

const express = require('express');
const app = express();
const mongo = require('mongodb').MongoClient
    , assert = require('assert');
const urlMongo = 'mongodb://127.0.0.1:27017/chatDB';
const logger = require('log4js').getLogger();
const multer = require('multer')
const upload = multer();
const tokenGenerator = require('uuid-token-generator');



app.post('/auth/', upload.array(), (req, res, next) => {
        logger.info('Запрос авторизации');
        mongo.connect(urlMongo, function(err, db) {
        assert.equal(null, err);
        console.log('Connected success with MongoDB');
        const log = req.headers.log;
        const pass = req.headers.password;
        
        db.collection("chatDB").find({login: log}).toArray((err, results) => {
            if (results[0]['password'] === pass) {
                const tokenGen = new tokenGenerator(256, tokenGenerator.BASE62);
                const token = tokenGen.generate();
                const json = {'token':token};
                db.collection('chatDB').update({user_id:results[0]['user_id']}, {$set: {token:token}});
                res.send(JSON.stringify(json));
                logger.info('Авторизован -> ' + results[0]['login']);
            } else {
                res.send(JSON.stringify('BAD'));
                logger.info('Пошел нахуй');
            }
            db.close();    
        });
        
    });
});

app.post('/register', upload.array(), (req, res, next) => {
    logger.info('Запрос авторизации');
    mongo.connect(urlMongo, function(err, db) {
        assert.equal(null, err);
        console.log('Connected success with MongoDB');
        const log = req.body.log;
        const pass = req.body.password;
        
        const authData = db.collection('chatDB').find({login: log}).toArray((err, results) => {
            if (results.length === 0) {
                const token = 'jfadf';
                db.collection('chatDB').insertOne({login: log, password: pass, token: token, socket_id: ''})
                res.send(token);
            } else {
                res.send('BAD');
            }
            
            db.close();    
        });
        
    });
});

app.listen(8080);
logger.info('Сервак запущен');