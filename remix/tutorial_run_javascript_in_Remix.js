const web3 = (async () => {
    try {
      const contractAddress = '0x82a97Fb95CE0C1aab70dfE0a4e296088654AD20a'
      const metadata = JSON.parse(await remix.call('fileManager', 'getFile', 'browser/contracts/artifacts/attack.json'))
      
      const accounts = await web3.eth.getAccounts()
  
      // console.log(metadata.abi)
      let contract = new web3.eth.Contract(metadata.abi, contractAddress)
      let tx = await contract.methods.attackNow().send({from: accounts[0]})
      console.log(tx);
  
    
    } catch (e) {
      console.log(e.message)
    }
  })
  
  const ethersjs = (async ()=> {
    try{
      const contractAddress = '0x82a97Fb95CE0C1aab70dfE0a4e296088654AD20a'
      const metadata = JSON.parse(await remix.call('fileManager', 'getFile', 'browser/contracts/artifacts/attack.json'))
      
      const signer = (new ethers.providers.Web3Provider(web3Provider)).getSigner()
      const accounts = await signer.getAddress();
      console.log(accounts)
  
      const contract = new ethers.Contract(contractAddress, metadata.abi, signer)
      const tx = await contract.attackNow()
    }catch(ex){
      console.log(ex.message)
    }
  })
  
  ethersjs()