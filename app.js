
var express = require('express'),
  app = express(),
  port = process.env.PORT || 3000,
  fs = require('fs'),
  bodyParser = require('body-parser'),
  SCController = require('easyweb3'), //My library to simplify smart contract interaction
  Web3 = require('web3'), //This is here just for testing
  web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));


//Rest server config and start
app.use(express.static(__dirname + '/client')) //To define what folder is the public directort
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
//Define where routes to access the server are
var routes = require('./API/Routes/ApiRoutes');
routes(app);
app.listen(port);
console.log('Lingotts\'s RESTful API server started on: ' + port);
console.log('This are the accounts of your node in order');
console.log(web3.eth.accounts);
