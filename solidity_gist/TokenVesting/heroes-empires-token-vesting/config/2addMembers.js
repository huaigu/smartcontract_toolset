require('dotenv').config();
PRIVATE_KEY = process.env.PRIVATE_KEY;
console.log('private' + PRIVATE_KEY)
const { Saveariable } = require('./constants')
const Web3 = require('web3');
const web3 = new Web3(Saveariable.rpc_bsc);
const account = web3.eth.accounts.privateKeyToAccount(PRIVATE_KEY);
const vestingInternal = Saveariable.vesting_internal;
//TokenVesting
const abiTokenVesting = require('../../../../abis/TokenVesting.json')
const contractTokenVesting = new web3.eth.Contract(abiTokenVesting.abi, Saveariable.contract_TokenVesting);

const config_member = [ Saveariable.config_private, Saveariable.config_sho, Saveariable.config_gate, Saveariable.config_marketing1, Saveariable.config_marketingecosystem, Saveariable.config_ingame1, Saveariable.config_ecosystem1, Saveariable.config_teamAdvisors]
AddBeneficiary()
//addBeneficiary
async function AddBeneficiary() {
    for(var i = 0; i < config_member.length; i++){
        // console.log(listContract[i])
        await addBeneficiary(contractTokenVesting, Saveariable.contract_TokenVesting, config_member[i]);
    }
    console.log("Done Add Beneficiary")
}

async function addBeneficiary(contractAbi, contractAddress, configMember) {
    const addressMember = configMember[0];
    const amount = configMember[1];
    const lock = configMember[2]*vestingInternal;
    const durationLock = configMember[3]*vestingInternal;
    const internal = configMember[4]*vestingInternal;
    const isaddress = Web3.utils.isAddress(addressMember)
    if(isaddress){
        const contract = await contractAbi.methods.addBeneficiary(addressMember, amount, lock, durationLock, 0, internal);
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