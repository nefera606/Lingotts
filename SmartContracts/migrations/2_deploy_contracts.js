var AccountIdFactory = artifacts.require("./AccountIdFactory.sol");

module.exports = function(deployer) {
  deployer.deploy(AccountIdFactory, web3.eth.accounts[0]);
};
