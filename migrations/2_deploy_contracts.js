var Attributes = artifacts.require("./Attributes.sol");
var Multiowned = artifacts.require("./Multiowned.sol");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MetaCoin);
};
