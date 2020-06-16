var express = require('express');
var router = express.Router();
var Wallet = require('ethereumjs-wallet')
var EthUtil = require('ethereumjs-util')
const Web3 = require("web3")
var Tx = require('ethereumjs-tx');

const testKovan = "https://kovan.infura.io/v3/bd759a8d4ecb45eaa6376cf022beeb9d";
const testRopsten = "https://ropsten.infura.io/v3/bd759a8d4ecb45eaa6376cf022beeb9d"
const testRinkeby = "https://rinkeby.infura.io/v3/bd759a8d4ecb45eaa6376cf022beeb9d"
const mainnet = "https://mainnet.infura.io/v3/bd759a8d4ecb45eaa6376cf022beeb9d"

const kovan = new Web3(new Web3.providers.HttpProvider(testKovan))
const ropsten = new Web3(new Web3.providers.HttpProvider(testRopsten))
const rinkeby = new Web3(new Web3.providers.HttpProvider(testRinkeby))
const main = new Web3(new Web3.providers.HttpProvider(mainnet))

const asyncMiddleware = fn =>
  (req, res, next) => {
    Promise.resolve(fn(req, res, next))
      .catch(next);
  };

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

/*
Returns the newly created wallet
{
  "publicKey": "string key",
  "privateKey": "string key",
  "address": "string key",
  "mnemonic": "string",
  "test": bool
}
*/
router.post('/create', function(req, res, next) {
  var obj = {
    publicKey: wallet.getPublicKeyString(),
    privateKey: wallet.getPrivateKeyString(),
    address: wallet.getAddressString(),
    mnemonic: wallet.mnemonic
  };
  res.send(obj);
});

/*
Returns the balance of XRP assigned to the wallet

Returns:  Integer number
*/
router.get('/balance/:network/:address', asyncMiddleware(async (req, res, next) => {
  var address = req.params.address;
  var network = req.params.network;
  let web3;
  switch (network) {
    case "kovan":
      web3 = kovan;
      break;
    case "ropsten":
      web3 = ropsten;
      break;
    case "rinkeby":
      web3 = rinkeby;
      break;

    default:
      web3 = main;
      break;
  }

  web3.eth.getBalance(address, function(err, result) {
    if (err) {
      res.send(obj);
    } else {
      res.send(web3.utils.fromWei(result, "ether"));
    }
  })
}));

// Get the transaction history of a particular account
router.get('/history/:address', asyncMiddleware(async (req, res, next) => {
  var address = req.params.address;
}));

router.post('/send', asyncMiddleware(async (req, res, next) => {
  const info = req.body;
  const amount = BigInt(req.body.amount);

  var privateKey = new Buffer(info.privateKey, 'hex')

  var rawTx = {
    nonce: '0x00',
    gasPrice: '0x09184e72a000',
    gasLimit: '0x2710',
    to: req.body.to,
    value: amount,
    data: '0x7f7465737432000000000000000000000000000000000000000000000000000000600057'
  }

  var tx = new Tx(rawTx);
  tx.sign(privateKey);

  var serializedTx = tx.serialize();

  web3.eth.sendRawTransaction(serializedTx.toString('hex'), function(err, hash) {
    if (!err)
      res.send("ok")
    else
      res.send("failed")
  });
}));


module.exports = router;
