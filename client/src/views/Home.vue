<template>
  <div>
    <main>
      <h1 id="theme" class="hachathonTitle">Hackathon</h1>
        <article>
          <h1 class="hashtableTitle">HashTable</h1>
          <div>
            <button v-if="!address" v-on:click="loadWeb3();">Connection à Metamask</button>
            <p class="connection"><b><i>Statut</i></b> &nbsp; : <span id="status">Connection requise...</span></p>
            <div v-if="address">
                <p>Address : {{ address }}</p>
                <p>Contract Address : <a class="address" href="https://testnet.bscscan.com/address/0xe8a303d1bbd43343fe9f3d6b7fbfe1c3bf6d4c8b" target="_blank">{{ contractAddress }}</a></p>
            </div>
          </div>
          <div v-if="owner" class="input">
            <input
                id="paramAddAddressToAllowed"
                v-model="paramAddAddressToAllowed"
                type="text"
                placeholder="Address to add"
              />
            <button v-on:click="addAddressToAllowed();">Add</button>
          </div>
          <div v-if="owner" class="input">
            <input
                id="paramRemoveAddressToAllowed"
                v-model="paramRemoveAddressToAllowed"
                type="text"
                placeholder="Address to remove"
              />
            <button v-on:click="removeAddressToAllowed();">Remove</button>
          </div>
          <div v-if="allowed" class="input">
            <input
                id="paramAddHash"
                v-model="paramAddHash"
                type="text"
                placeholder="Hash to add"
              />
            <button v-on:click="addHash();">Add</button>
          </div>
          <div class="input">
            <input
                id="paramGetAddressAllowed"
                v-model="paramGetAddressAllowed"
                type="text"
                placeholder="Address to get"
              />
            <button v-on:click="getAddressAllowed();">Check</button>
          </div>
          <div class="input">
            <input
                id="paramVerifyHash"
                v-model="paramVerifyHash"
                type="text"
                placeholder="Hash to verify"
              />
            <button v-on:click="verifyHash();">Verify</button>
          </div>
          <div class="input">
            <input
                id="paramGetHash"
                v-model="paramGetHash"
                type="text"
                placeholder="Index to get"
              />
            <button v-on:click="getHash();">Get the hash</button>
          </div>
          <div><button v-on:click="getHashTableLength();">Get the length of the table</button></div>
          <div>
            <p class="resultP" v-if="resultCall">{{ resultCall }}</p>
          </div>
          <div>
            <div v-if="noweb3">
                <a href="https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn" target="_blank"><img src="https://www.french-ico.com/wp-content/uploads/2020/11/metamask-2-1.png" alt="Logo Metamask" /></a>
            </div>
          </div>

        </article>
    </main>
  </div>
</template>

<script>
export default {
  data () {
    return {
      noweb3: false,
      address: undefined,
      contractAddress: undefined,
      chainId: undefined,
      lastBlock: undefined,
      contract: undefined,
      web3: undefined,
      paramGetHash: undefined,
      paramVerifyHash: undefined,
      paramGetAddressAllowed: undefined,
      paramAddHash: undefined,
      paramRemoveAddressToAllowed: undefined,
      paramAddAddressToAllowed: undefined,
      owner: undefined,
      allowed: undefined,
      result: undefined,
      resultCall: undefined
    }
  },
  methods: {
    loadWeb3: async function () {
      const Web3 = require('web3')
      if (window.ethereum) {
        this.web3 = new Web3(window.ethereum)
        await window.ethereum.enable()
        await this.web3.eth.getAccounts()
          .then(e => {
            console.log(e[0])
            this.address = e[0]
          })
        this.web3.eth.getChainId()
          .then(e => {
            console.log(e)
            this.chainId = e
          })
        this.web3.eth.getBlockNumber()
          .then(e => {
            console.log(e)
            this.lastBlock = e
          })
        this.updateStatus('&nbsp; Connecté &nbsp; <i class="fas fa-check-circle"></i>', true)
        const contractAddress = '0xE8a303D1bBD43343FE9f3D6B7fBFe1C3bF6d4c8B'
        this.contractAddress = contractAddress
        const ABIContract = require('../abi/ABIContract.js')
        const abi = ABIContract.ABI
        this.contract = await new this.web3.eth.Contract(abi, contractAddress)
        await this.printOwner(this.address)
        await this.printAllowed(this.address)
      } else {
        this.updateStatus('&nbsp; Metamask non detecté &nbsp; <i class="fas fa-times-circle"></i>', false)
        this.noweb3 = true
      }
    },
    updateStatus: function (status, connected) {
      const connectionStatus = document.getElementById('status')
      console.log(connectionStatus.innerHTML)
      connectionStatus.innerHTML = status
      if (connected) {
        connectionStatus.style.color = 'green'
      } else {
        connectionStatus.style.color = 'red'
      }
      console.log(status)
    },
    addAddressToAllowed: async function () {
      this.resetResult()
      this.resultCall = await this.contract.methods.addAddressToAllowed(this.paramAddAddressToAllowed).send({
        from: this.address,
        to: this.contractAddress
      })
      this.resultCall = 'Address added ➡️ Transaction Hash : ' + this.resultCall.transactionHash
    },
    removeAddressToAllowed: async function () {
      this.resetResult()
      this.resultCall = await this.contract.methods.removeAddressToAllowed(this.paramRemoveAddressToAllowed).send({
        from: this.address,
        to: this.contractAddress
      })
      this.resultCall = 'Address removed ➡️ Transaction Hash : ' + this.resultCall.transactionHash
    },
    addHash: async function () {
      this.resetResult()
      this.resultCall = await this.contract.methods.addHash(this.paramAddHash).send({
        from: this.address,
        to: this.contractAddress
      })
      this.resultCall = 'Hash added ➡️ Transaction Hash : ' + this.resultCall.transactionHash
    },
    getAddressAllowed: async function () {
      this.resetResult()
      this.resultCall = await this.contract.methods.getAddressAllowed(this.paramGetAddressAllowed).call()
      if (this.resultCall === true) {
        this.resultCall = '✅ Your address is allowed'
      } else {
        this.resultCall = '❌ Your address is not allowed'
      }
    },
    verifyHash: async function () {
      this.resetResult()
      this.resultCall = await this.contract.methods.verifyHash(this.paramVerifyHash).call()
      if (this.resultCall === true) {
        this.resultCall = '👍 Your hash is in the hash table'
      } else {
        this.resultCall = '🙅‍♂️ Your hash is not in the hash table'
      }
    },
    getHash: async function () {
      this.resetResult()
      this.resultCall = await this.contract.methods.getHash(this.paramGetHash).call()
      this.resultCall = '📜 Hash number ' + this.paramGetHash + ' = ' + this.resultCall
    },
    getHashTableLength: async function () {
      this.resetResult()
      this.resultCall = await this.contract.methods.getHashTableLength().call()
      this.resultCall = '📏 Hash Table length is : ' + this.resultCall
    },
    printOwner: async function (address) {
      if (address === await this.contract.methods.owner.call().call()) {
        this.owner = true
      }
    },
    printAllowed: async function (address) {
      this.allowed = await this.contract.methods.getAddressAllowed(address).call()
    },
    resetResult: function () {
      this.resultCalls = undefined
    }
  }
}
</script>
