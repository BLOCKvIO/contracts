var ReadPoolLedger = artifacts.require("./ReadPoolLedger.sol");

module.exports = function(deployer) {
  deployer.deploy(ReadPoolLedger);
};
