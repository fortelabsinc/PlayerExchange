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
  "address": "string key",
  "mnemonic": "string",
  "derivation": "string"
}
*/
router.post('/create', function(req, res, next) {
  const generationResult = Wallet.generateRandomWallet(undefined, true);
  const wallet = generationResult.wallet;
  var obj = {
    publicKey: wallet.getPublicKey(),
    privateKey: wallet.getPrivateKey(),
    address: wallet.getAddress(),
    mnemonic: generationResult.mnemonic,
    derivation: generationResult.derivationPath
  };
  res.send(obj);
});

/*
Returns the balance of XRP assigned to the wallet

Returns:  Integer number
*/
router.get('/balance/:network/:address', asyncMiddleware(async (req, res, next) => {
  var address = req.params.address;
  var url = testNet;
  var net = XRPLNetwork.Test;
  if (network == "main") {
    url = mainNet;
    net = XRPLNetwork.Main;
  }
  const xrpClient = new XRPClient(url, net);
  const balance = await xrpClient.getBalance(address);
  res.send(balance);
}));

router.get('/history/:address', asyncMiddleware(async (req, res, next) => {
  var address = req.params.address;
  const xrpClient = new XRPClient(testNet, XRPLNetwork.Test);
  var tran = await xrpClient.paymentHistory(address);
  for (var index = 0; index < tran.length; ++index) {
    tran[index]["account"] = Utils.encodeXAddress(tran[index]["account"], undefined, true);
    tran[index]["paymentFields"]["destination"] = Utils.encodeXAddress(tran[index]["paymentFields"]["destination"], undefined, true);
  }
  res.send(tran);
}));

router.get('/status/:hash', asyncMiddleware(async (req, res, next) => {
  var hash = req.params.hash;
  const xrpClient = new XRPClient(testNet, XRPLNetwork.Test);
  const data = await xrpClient.getPaymentStatus(hash);
  res.send(JSON.stringify(data));
}));

router.get('/payment/:hash', asyncMiddleware(async (req, res, next) => {
  const hash = req.params.hash;
  const xrpClient = new XRPClient(testNet, XRPLNetwork.Test);
  let tran = await xrpClient.getPayment(hash);
  tran["account"] = Utils.encodeXAddress(tran["account"], undefined, true);
  tran["paymentFields"]["destination"] = Utils.encodeXAddress(tran["paymentFields"]["destination"], undefined, true);
  res.send(tran);
}));

router.get('/payment/:address/:hash', asyncMiddleware(async (req, res, next) => {
  const hash = req.params.hash;
  const address = req.params.address;
  const xrpClient = new XRPClient(testNet, XRPLNetwork.Test);
  const status = await xrpClient.paymentHistory(address);
  var sendDefault = true;
  for (var index = 0; index < status.length; ++index) {
    if (status[index].hash == hash) {
      var tran = status[index];
      tran["account"] = Utils.encodeXAddress(tran["account"], undefined, true);
      tran["paymentFields"]["destination"] = Utils.encodeXAddress(tran["paymentFields"]["destination"], undefined, true);
      res.send(status[index]);
      sendDefault = false;
      break;
    }
  }

  if (sendDefault) {
    res.send("not_found")
  }
}));


router.get('/balance/:address', asyncMiddleware(async (req, res, next) => {
  var address = req.params.address;
  const xrpClient = new XRPClient(testNet, XRPLNetwork.Test);
  const balance = await xrpClient.getBalance(address);
  res.send(balance);
}));

router.post('/send', asyncMiddleware(async (req, res, next) => {
  const info = req.body;
  const amount = BigInt(req.body.amount);
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
