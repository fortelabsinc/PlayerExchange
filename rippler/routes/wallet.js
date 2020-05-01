var express = require('express');
var router = express.Router();
const { Wallet, XRPAmount, XRPClient, XRPLNetwork, Utils } = require("xpring-js");
var bip39 = require('bip39');

const testNet = "test.xrp.xpring.io:50051";
const mainNet = "main.xrp.xpring.io:50051";

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
  "test": bool
}
*/
router.post('/create', function(req, res, next) {
  const generationResult = Wallet.generateRandomWallet(undefined, true);
  const wallet = generationResult.wallet;
  var obj = {};
  obj["publicKey"] = wallet.getPublicKey();
  obj["privateKey"] = wallet.getPrivateKey();
  obj["address"] = wallet.getAddress();
  obj["mnemonic"] = generationResult.mnemonic;
  obj["derivation"] = generationResult.derivationPath;
  res.send(obj);
});

//router.post('/facet', function(req, res, next) {
//  const generationResult = Wallet.generateRandomWallet(undefined, true);
//  const newWallet = generationResult.wallet;
//  res.send(newWallet);
//});

router.get('/balance/:address', asyncMiddleware(async (req, res, next) => {
  var address = req.params.address;
  console.log("Getting balance for user: " + address);
  const xrpClient = new XRPClient(testNet, XRPLNetwork.Test);
  const balance = await xrpClient.getBalance(address);
  res.send(balance);
}));

router.get('/history/:address', asyncMiddleware(async (req, res, next) => {
  var address = req.params.address;
  const xrpClient = new XRPClient(testNet, XRPLNetwork.Test);
  const transactions = await xrpClient.paymentHistory(address);
  res.send(transactions);
}));

router.get('/status/:hash', function(req, res, next) {
  var hash = req.params.hash;
  const xrpClient = new XRPClient(testNet, XRPLNetwork.Test);
  const status = xrpClient.getPaymentStatus(hash);
  res.send(status);
});

router.get('/balance/:address', asyncMiddleware(async (req, res, next) => {
  var address = req.params.address;
  console.log("Getting balance for user: " + address);
  const xrpClient = new XRPClient(testNet, XRPLNetwork.Test);
  const balance = await xrpClient.getBalance(address);
  res.send(balance);
}));

router.post('/send', asyncMiddleware(async (req, res, next) => {
  const info = req.body;
  const amount = BigInt("10");
  var wallet = undefined;
  const xrpClient = new XRPClient(testNet, XRPLNetwork.Test);
  if ("mnemonic" == info.type) {
    wallet = Wallet.generateWalletFromMnemonic(info.from);
  }
  else {
    wallet = Wallet.generateWalletFromSeed(info.from);
  }
  const transactionHash = await xrpClient.send(amount, info.to, wallet);
  res.send(transactionHash)
}));

module.exports = router;
