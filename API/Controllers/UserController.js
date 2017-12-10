'use strict';

//Var for deployment configuration
var userManagerJson = './SmartContracts/build/contracts/AccountIdFactory.json';

//Var declaration for Libraries
var SCController = require('easyweb3'),
    fs = require('fs');
var Web3 = require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));


//Get DAO contract instance
var userManagerObj = JSON.parse(fs.readFileSync(userManagerJson, 'utf8')); //Read abi from contract
var userManagerAddress = SCController.getLatestAddress(userManagerObj);
var instanceUserManagerContract = SCController.getContractInstance(userManagerObj.abi, userManagerAddress);

exports.list_all_users = function(req, res) {
  var usersLength = parseInt(instanceUserManagerContract.getNumAccounts());
  var parsedUsers = [];
  for (var i = 0; i < usersLength; i++) {
    var user = instanceUserManagerContract.accountList(i);
    if (!user[2]){
      var parsedUser = {
          UserName: user[0],
          id:user[1]
      };
      parsedUsers.push(parsedUser);
    }
  }
  res.json(parsedUsers);
};

exports.create_a_user = function(req, res) {
  if (req.body.UserName != undefined){
    instanceUserManagerContract.create(req.body.UserName, {from:web3.eth.accounts[0], gas:2000000});
    res.send('Storing your new company on the blockchain, the verification process may take a couple of minutes');
  }else {
    res.send('The json sent is missing some critical fields');
  }
};

exports.delete_a_user = function(req, res) {
  instanceUserManagerContract.remove(req.params.UserName);
  res.send('The user was removed'); //TODO: Pick answer as blk event
};

 exports.list_a_user = function(req, res) {
   var user = instanceUserManagerContract.getUserExternal(req.params.UserName, {gas: 2000000});
   var responseObject = {};
   responseObject.UserName = user[0];
   responseObject.id = user[1];
   responseObject.deleted = user[2];
   res.json(responseObject);
 };

 exports.is_a_user = function(req, res) {
   console.log(web3.eth.accounts[0]);
  var result = parseInt(instanceUserManagerContract.isUser(req.params.UserName));
  if(result == 1)
    res.send('You are that user, auth correct ');
  else if (result == 0)
    res.send('You are not that user, auth failed');
  else if (result == 2)
    res.send('User does not exist');
 };
