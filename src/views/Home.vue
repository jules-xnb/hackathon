<template>
  <div>
    <main>
      <h1 id="theme">Hackathon</h1>
        <article>
          <h1>HashTable</h1>
          <div>
            <button v-if="!address" v-on:click="loadWeb3();">Connection à Metamask</button>
            <p><b><i>Statut</i></b> &nbsp; : <span id="status">Connection requise...</span></p>
            <div v-if="address">
                <p>Address : {{ address }}</p>
                <p>Contract Address : <a href="https://testnet.bscscan.com/address/0xe8a303d1bbd43343fe9f3d6b7fbfe1c3bf6d4c8b" target="_blank">{{ contractAddress }}</a></p>
            </div>
          </div>
          <div v-if="owner" class="input">
            <input
                id="paramAddAddressToAllowed"
                v-model="paramAddAddressToAllowed"
                type="text"
                placeholder="Address to add"
              />
            <button v-on:click="addAddressToAllowed();">addAddressToAllowed</button>
          </div>
          <div v-if="owner" class="input">
            <input
                id="paramRemoveAddressToAllowed"
                v-model="paramRemoveAddressToAllowed"
                type="text"
                placeholder="Address to remove"
              />
            <button v-on:click="removeAddressToAllowed();">removeAddressToAllowed</button>
          </div>
          <div v-if="allowed" class="input">
            <input
                id="paramAddHash"
                v-model="paramAddHash"
                type="text"
                placeholder="Hash to add"
              />
            <button v-on:click="addHash();">addHash</button>
          </div>
          <div class="input">
            <input
                id="paramGetAddressAllowed"
                v-model="paramGetAddressAllowed"
                type="text"
                placeholder="Address to get"
              />
            <button v-on:click="getAddressAllowed();">checkIfAddressIsAllowed</button>
          </div>
          <div class="input">
            <input
                id="paramVerifyHash"
                v-model="paramVerifyHash"
                type="text"
                placeholder="Hash to verify"
              />
            <button v-on:click="verifyHash();">verifyHash</button>
          </div>
          <div class="input">
            <input
                id="paramGetHash"
                v-model="paramGetHash"
                type="text"
                placeholder="Index to get"
              />
            <button v-on:click="getHash();">getHash</button>
          </div>
          <div><button v-on:click="getHashTableLength();">getHashTableLength</button></div>
          <div>
            <p v-if="result1">{{ result1 }}</p>
            <p v-if="result2">{{ result2 }}</p>
            <p v-if="result3">{{ result3 }}</p>
            <p v-if="result4">{{ result4 }}</p>
            <p v-if="result5">{{ result5 }}</p>
            <p v-if="result6">{{ result6 }}</p>
            <p v-if="result7">{{ result7 }}</p>
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
      result1: undefined,
      result2: undefined,
      result3: undefined,
      result4: undefined,
      result5: undefined,
      result6: undefined,
      result7: undefined
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
      this.result1 = await this.contract.methods.addAddressToAllowed(this.paramAddAddressToAllowed).send({
        from: this.address,
        to: this.contractAddress
      })
      this.result1 = 'Address added ➡️ Transaction Hash : ' + this.result1.transactionHash
    },

    removeAddressToAllowed: async function () {
      this.resetResult()
      this.result2 = await this.contract.methods.removeAddressToAllowed(this.paramRemoveAddressToAllowed).send({
        from: this.address,
        to: this.contractAddress
      })
      this.result2 = 'Address removed ➡️ Transaction Hash : ' + this.result2.transactionHash
    },

    addHash: async function () {
      this.resetResult()
      this.result3 = await this.contract.methods.addHash(this.paramAddHash).send({
        from: this.address,
        to: this.contractAddress
      })
      this.result3 = 'Hash added ➡️ Transaction Hash : ' + this.result3.transactionHash
    },

    getAddressAllowed: async function () {
      this.resetResult()
      this.result4 = await this.contract.methods.getAddressAllowed(this.paramGetAddressAllowed).call()
      if (this.result4 === true) {
        this.result4 = '✅ Your address is allowed'
      } else {
        this.result4 = '❌ Your address is not allowed'
      }
    },

    verifyHash: async function () {
      this.resetResult()
      this.result5 = await this.contract.methods.verifyHash(this.paramVerifyHash).call()
      if (this.result5 === true) {
        this.result5 = '👍 Your hash is in the hash table'
      } else {
        this.result5 = '🙅‍♂️ Your hash is not in the hash table'
      }
    },

    getHash: async function () {
      this.resetResult()
      this.result6 = await this.contract.methods.getHash(this.paramGetHash).call()
      this.result6 = '📜 Hash number ' + this.paramGetHash + ' = ' + this.result6
    },

    getHashTableLength: async function () {
      this.resetResult()
      this.result7 = await this.contract.methods.getHashTableLength().call()
      this.result7 = '📏 Hash Table length is : ' + this.result7
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
      this.result1 = undefined
      this.result2 = undefined
      this.result3 = undefined
      this.result4 = undefined
      this.result5 = undefined
      this.result6 = undefined
      this.result7 = undefined
    }

  }
}
</script>
