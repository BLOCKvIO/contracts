var Tx = require('ethereumjs-tx');
var Web3 = require('web3');

var web3 = new Web3(new Web3.providers.HttpProvider("http://ethereum1.watercoins.io:8545"));
//var privateKey = new Buffer('e331b6d69882b4cb4ea581d88e0b604039a3de5967688d3dcffdd2270c0fd109', 'hex')
var privateKey = new Buffer('e0593678d40d82366ce6ee681bbe5d4c0b7eb652df666f7e156ff68e2f70e4c9', 'hex')

/*var rawTx = {
  nonce: '0x5BBF',
  gasPrice: '0x09184e72a000', 
  gasLimit: '0x2710',
  to: '0x1b5d225BAd08686BA81C804960f2288b1e42AfD0', 
  value: '0x00', 
  data: '0xfdacd5760000000000000000000000000000000000000000000000000000000000000001'
  //data: '0x7f7465737432000000000000000000000000000000000000000000000000000000600057'
}*/

var rawTx = {
  nonce: '0x5BEF',
  gasPrice: '0x09184e72a000', 
  gasLimit: '0xF4240',
  to: '0xdC1bc219A73ef7F0cf9fBe60f9F360eAfd10B791', 
  value: '0x09184e72a000', 
  data: '0xa1f39bae'
  //data: '0x7f7465737432000000000000000000000000000000000000000000000000000000600057'
}

var tx = new Tx(rawTx);
tx.sign(privateKey);
var serializedTx = tx.serialize();

//console.log(serializedTx.toString('hex'));
//console.log(web3.eth)
web3.eth.sendSignedTransaction('0x'+serializedTx.toString('hex'))
.on('receipt', console.log);