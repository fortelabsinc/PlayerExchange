var express = require('express');
var router = express.Router();
var Wallet = require('ethereumjs-wallet')
var EthUtil = require('ethereumjs-util')

router.get('/ping', function(req, res, next) {
  // Get a wallet instance from a private key
  const privateKeyBuffer = EthUtil.toBuffer(
    '0xb56571b162358ec7566c95ee16883799b98158b6aa8295db7c6044fb79457343'
  )
  const wallet = Wallet.fromPrivateKey(privateKeyBuffer)

  // Get a public key
  const address = wallet.getAddressString()
  const privKey = wallet.getPrivateKeyString()
  const pubKey = wallet.getPublicKeyString()
  console.log(address)
  console.log(privKey)
  console.log(pubKey)

  console.log('*****')

  const wallet2 = Wallet.generate()
  const address2 = wallet2.getAddressString()
  const privKey2 = wallet2.getPrivateKeyString()
  const pubKey2 = wallet2.getPublicKeyString()
  console.log(address2)
  console.log(privKey2)
  console.log(pubKey2)

  res.send('pong');
});
//const { Wallet, XRPAmount, XRPClient, XRPLNetwork, Utils } = require("xpring-js");
//var bip39 = require('bip39');
//
//const testNet = "test.xrp.xpring.io:50051";
//const mainNet = "main.xrp.xpring.io:50051";
//
//const asyncMiddleware = fn =>
//  (req, res, next) => {
//    Promise.resolve(fn(req, res, next))
//      .catch(next);
//  };
//
///* GET users listing. */
//router.get('/', function(req, res, next) {
//  res.send('respond with a resource');
//});
//
///*
//Returns the newly created wallet
//{
//  "publicKey": "string key",
//  "privateKey": "string key",
//  "test": bool
//}
//*/
//router.post('/create', function(req, res, next) {
//  const generationResult = Wallet.generateRandomWallet(undefined, true);
//  const wallet = generationResult.wallet;
//  var obj = {};
//  obj["publicKey"] = wallet.getPublicKey();
//  obj["privateKey"] = wallet.getPrivateKey();
//  obj["address"] = wallet.getAddress();
//  obj["mnemonic"] = generationResult.mnemonic;
//  obj["derivation"] = generationResult.derivationPath;
//  res.send(obj);
//});
//
////router.post('/facet', function(req, res, next) {
////  const generationResult = Wallet.generateRandomWallet(undefined, true);
////  const newWallet = generationResult.wallet;
////  res.send(newWallet);
////});
//
//router.get('/balance/:address', asyncMiddleware(async (req, res, next) => {
//  var address = req.params.address;
//  console.log("Getting balance for user: " + address);
//  const xrpClient = new XRPClient(testNet, XRPLNetwork.Test);
//  const balance = await xrpClient.getBalance(address);
//  res.send(balance);
//}));
//
//router.get('/history/:address', asyncMiddleware(async (req, res, next) => {
//  var address = req.params.address;
//  const xrpClient = new XRPClient(testNet, XRPLNetwork.Test);
//  var tran = await xrpClient.paymentHistory(address);
//  for (var index = 0; index < tran.length; ++index) {
//    tran[index]["account"] = Utils.encodeXAddress(tran[index]["account"], undefined, true);
//    tran[index]["paymentFields"]["destination"] = Utils.encodeXAddress(tran[index]["paymentFields"]["destination"], undefined, true);
//  }
//  res.send(tran);
//}));
//
//router.get('/status/:hash', asyncMiddleware(async (req, res, next) => {
//  var hash = req.params.hash;
//  const xrpClient = new XRPClient(testNet, XRPLNetwork.Test);
//  const data = await xrpClient.getPaymentStatus(hash);
//  res.send(JSON.stringify(data));
//}));
//
//router.get('/payment/:hash', asyncMiddleware(async (req, res, next) => {
//  const hash = req.params.hash;
//  const xrpClient = new XRPClient(testNet, XRPLNetwork.Test);
//  let tran = await xrpClient.getPayment(hash);
//  tran["account"] = Utils.encodeXAddress(tran["account"], undefined, true);
//  tran["paymentFields"]["destination"] = Utils.encodeXAddress(tran["paymentFields"]["destination"], undefined, true);
//  res.send(tran);
//}));
//
//router.get('/payment/:address/:hash', asyncMiddleware(async (req, res, next) => {
//  const hash = req.params.hash;
//  const address = req.params.address;
//  const xrpClient = new XRPClient(testNet, XRPLNetwork.Test);
//  const status = await xrpClient.paymentHistory(address);
//  var sendDefault = true;
//  for (var index = 0; index < status.length; ++index) {
//    if (status[index].hash == hash) {
//      var tran = status[index];
//      tran["account"] = Utils.encodeXAddress(tran["account"], undefined, true);
//      tran["paymentFields"]["destination"] = Utils.encodeXAddress(tran["paymentFields"]["destination"], undefined, true);
//      res.send(status[index]);
//      sendDefault = false;
//      break;
//    }
//  }
//
//  if (sendDefault) {
//    res.send("not_found")
//  }
//}));
//
//
//router.get('/balance/:address', asyncMiddleware(async (req, res, next) => {
//  var address = req.params.address;
//  const xrpClient = new XRPClient(testNet, XRPLNetwork.Test);
//  const balance = await xrpClient.getBalance(address);
//  res.send(balance);
//}));
//
//router.post('/send', asyncMiddleware(async (req, res, next) => {
//  const info = req.body;
//  const amount = BigInt(req.body.amount);
//  var wallet = undefined;
//  const xrpClient = new XRPClient(testNet, XRPLNetwork.Test);
//  if ("mnemonic" == info.type) {
//    wallet = Wallet.generateWalletFromMnemonic(info.from);
//  }
//  else {
//    wallet = Wallet.generateWalletFromSeed(info.from);
//  }
//  const transactionHash = await xrpClient.send(amount, info.to, wallet);
//  res.send(transactionHash)
//}));

module.exports = router;
