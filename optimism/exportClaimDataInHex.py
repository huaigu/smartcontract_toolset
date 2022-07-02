# borrowed from RobotDAO community

# Modify for export multiple claim data in hex format 
# and manually interacting with official optimistic claim contract

import json

import requests
import web3
from web3 import Web3


class Op:

    def __init__(self):
        self.w3 = Web3(Web3.HTTPProvider("https://opt-mainnet.g.alchemy.com/v2/CxLRRuTWCsK6jLgZhEBhY3gU5mUX5ciD"))

    def build_hex_str(self, address_str):
        response = requests.get(f"https://gateway-backend-mainnet.optimism.io/proof/{address_str}")

        if response.status_code != 200:
            print("网络错误")
            return

        content = json.loads(response.text)

        contract = self.w3.eth.contract(Web3.toChecksumAddress("0xfedfaf1a10335448b7fa0268f56d2b44dbd357de"), abi=[
            {
                "inputs": [
                    {
                        "internalType": "uint256",
                        "name": "index",
                        "type": "uint256"
                    },
                    {
                        "internalType": "address",
                        "name": "account",
                        "type": "address"
                    },
                    {
                        "internalType": "uint256",
                        "name": "amount",
                        "type": "uint256"
                    },
                    {
                        "internalType": "bytes32[]",
                        "name": "merkleProof",
                        "type": "bytes32[]"
                    }
                ],
                "name": "claim",
                "outputs": [],
                "stateMutability": "nonpayable",
                "type": "function"
            }
        ])

        index = content['index']
        account = address_str
        amount = int(content['amount'], 16)
        proof = content['proof']
        contra_call = contract.functions.claim(index, account, amount, proof)
        transaction = contract.functions.claim(index, account, amount, proof).buildTransaction({
            "value": Web3.toWei(0, "ether"),
            "gasPrice": Web3.toWei(1, 'gwei'),
            "gas": 1000000
        })

        print(transaction['data'][2:])



op = Op()
addr_list = [
    "0x3d833De7728f0*****43Cd7788eBF99Df034",
    "0x80C70614617689*****E0f17F0B8c2b3D4815",
    "0x7f309589C13D1e*****A74882A1555E7839Be",
    "0xB5f1e95e4Bcc59*****fcd6f09ef3e596f8f5B",
    "0x4B1102a1c4cB648*****eFbD266E54c1F0ee0",

]
for item in addr_list:
    op.build_hex_str(item)

op.build_hex_str("0x8b897E5E3F1d11*****74b2eF350f04f66B3C3")