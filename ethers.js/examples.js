import { ethers } from "ethers";

function createWallet() {
    const wallet = ethers.Wallet.createRandom();
    console.log("Wallet 1:", wallet.address);
    return wallet;
}

function createWallet2() {
    var privateKey = ethers.utils.randomBytes(32);
    let privateKeyInHexStr = ethers.utils.hexlify(privateKey);
    console.log("PrivateKey: " + privateKeyInHexStr); // print privateKey in hex string
    var wallet = new ethers.Wallet(privateKey);
    console.log("Wallet 2:", wallet.address);
    return wallet;
}

function createWalletFromPrivateKeyString() {
    const privateKey = "0x0123456789012345678901234567890123456789012345678901234567890123";
    const wallet = new ethers.Wallet(privateKey);
    console.log("Wallet 3:", wallet.address);
    return wallet;
}

async function createKeyStore() {
    const randomWallet = await ethers.Wallet.createRandom();
    console.log("keyStore wallet: ", randomWallet.address);
    const keyStore = await randomWallet.encrypt("password");
    console.log("KeyStore:", keyStore);
    return keyStore;
}

async function restoreWalletFromKeyStore(keystoreJSONStr, passward) {
    // var fileReader = new FileReader();
    const keyStore = await ethers.Wallet.fromEncryptedJson(keystoreJSONStr, passward);
    console.log("Wallet 4_fromKeyStore:", keyStore.address);
}

async function testWallets() {
    createWallet();
    createWallet2();
    createWalletFromPrivateKeyString();

    // keystore
    const keyStore = await createKeyStore();
    await restoreWalletFromKeyStore(keyStore, "password");
}

// testWallets();


/*
Providers
*/

function createProvider() {
    let defaultProvider = ethers.getDefaultProvider('ropsten');
    console.log("Default Provider:");
    console.log(defaultProvider);
}

function createJsonRpcProvider() {
    var provider = new ethers.providers.JsonRpcProvider("http://127.0.0.1:8545");
    console.log("JsonRpcProvider:");
    console.log(provider);
}

function createWeb3Provider() {
    var provider = new ethers.providers.Web3Provider(web3.currentProvider);
    console.log("Web3Provider:");
    console.log(provider);
}

function createInfuraProvider() {
    var provider = new ethers.providers.InfuraProvider("ropsten", "YOUR_INFURA_API_KEY");
    console.log("Infura provider:");
    console.log(provider);
}

function testProviders() {
    createProvider();
    createJsonRpcProvider();
}

testProviders();

/*
signers, connected address
*/

// get current connected address after user switch wallet address
async function getConnectedAddress() {

    // init provider and get default account
    let provider = new ethers.providers.Web3Provider(window.ethereum);
    await provider.send("eth_requestAccounts", []);
    signer = provider.getSigner();
    let addressWhenWalletConneted = await signer.getAddress();
    console.log(`signer address: ${addressWhenWalletConneted}`);

    // user switch wallet address using metamask
    // ...

    // get current connected address
    let curSigner = provider.getSigner();
    console.log(`current signer address: ${await curSigner.getAddress()}`); // current connected address
    console.log(`default signer address: ${await signer.getAddress()}`); // same as addressWhenWalletConneted
}


/* 
Transactions
*/

async function writeContract() {
    // estimate gas
    let estimateGasLimit = await contract.estimateGas.mint()
    estimateGasLimit = estimateGasLimit.add(10000)
    console.log(estimateGasLimit)
    var options = { gasLimit: estimateGasLimit, value: 0 };
    const tx = await contract.mint(options)
}


/* utils */
async function hash(){
  // compute keccak256 hash
  // id[STRING] == keccak256(utils.toUtf8Bytes[STRING])
  console.log(ethers.utils.id("mint(uint256)"));
  console.log(ethers.utils.keccak256(ethers.utils.toUtf8Bytes("mint(uint256)", '')));
  
  // method signature
  console.log("0x" + ethers.utils.id("mint(uint256)").substring(0,8));
}

