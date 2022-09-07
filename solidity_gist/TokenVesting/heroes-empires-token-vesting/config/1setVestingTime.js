require('dotenv').config();
PRIVATE_KEY = process.env.PRIVATE_KEY;
console.log('private' + PRIVATE_KEY)
const { Saveariable } = require('./constants')
const Web3 = require('web3');
const web3 = new Web3(Saveariable.rpc_bsc);
const account = web3.eth.accounts.privateKeyToAccount(PRIVATE_KEY);
//TokenVesting
const abiTokenVesting = require('../../../../abis/TokenVesting.json')
const contractTokenVesting = new web3.eth.Contract(abiTokenVesting.abi, Saveariable.contract_TokenVesting);
SetVesting()
async function SetVesting(){
    await setVesting(contractTokenVesting, Saveariable.time_set, Saveariable.contract_TokenVesting)
    console.log("Done Set Vesting Time")
}

async function setVesting(contractVesting, timeVesting, contractAddress){
    const isaddress = Web3.utils.isAddress(contractAddress)
    if(isaddress){
        const contract = await contractVesting.methods.setTokenListingDate(timeVesting);
        const options = {
            to: contractAddress,
            data: contract.encodeABI(),
            gas: await contract.estimateGas({ from: account.address }),
            gasPrice: await web3.eth.getGasPrice()
        }; 
        const signed = await web3.eth.accounts.signTransaction(options, PRIVATE_KEY);
        const receipt = await web3.eth.sendSignedTransaction(signed.rawTransaction);
        console.log(receipt)
    }else{
        console.log("Fail")
    }
}