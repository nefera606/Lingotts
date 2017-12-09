var VTNUserManager = artifacts.require("./VTNUserManager.sol");

module.exports = function(deployer) {
  deployer.deploy(VTNUserManager, web3.eth.accounts[0]);
};
