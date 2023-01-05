# ConcertX

To empower musicians and bring unique concerts to life through the support of their fans and backers, while also creating a sustainable and innovative platform that leverages the power of emerging technologies.

ConcertX aims to disrupt and transform the music industry by providing a platform for musicians to set up crowdfunding campaigns and offer unique rewards to their backers. By empowering musicians to have more control over their careers and creative processes, ConcertX seeks to facilitate collaboration and allow fans to interact with musicians in real time. By using blockchain technology and smart contracts, ConcertX creates a decentralized and transparent crowdfunding platform that reduces fees and barriers to entry, and by using innovative technologies like virtual reality. Through these efforts, ConcertX seeks to bring to create an immersive and revolutionary concert experience for both musicians and their audiences.

## Setting Up
### 1. Clone/Download the Repository

### 2. Install Dependencies:
```
$ cd concertx-smartcontracts
$ npm install
```
## 1. Boot up local development blockchain

```bash
$ npx hardhat node
```

## 2. Connect development blockchain accounts to Metamask

- Copy private key of the addresses and import to MetaMask
- Connect your MetaMask to Hardhat blockchain, network 127.0.0.1:8545.
- If you have not added hardhat to the list of networks on your MetaMask, open up a browser, click the fox  icon, then click the top center dropdown button that lists all the available networks then click add networks. A form should pop up. For the "Network Name" field enter "Hardhat". For the "New RPC URL" field enter "http://127.0.0.1:8545". For the chain ID enter "1337". Then click save.

Note: due to an existing error between MetaMask and hardhat, the chainId must be passed manually. By default it does not take it, since both are different. See more here: 

- MetaMask [error](https://github.com/MetaMask/metamask-extension/issues/10290)
- Hardhat [solution](https://github.com/NomicFoundation/hardhat-boilerplate/blob/master/hardhat.config.js#L13)

## To interact with a live or test network, you'll need:

1. An rpc URL
2. A Private Key
3. MATIC or ETH token (either testnet or real)

Let's look at an example of setting these up using the Mumbai testnet. 

### Mumbai Testnet Setup

First, we will need to set environment variables. We can do so by setting them in our `.env` file (create it if it's not there). You can also read more about [environment variables](https://www.twilio.com/blog/2017/01/how-to-set-environment-variables.html) from the linked twilio blog. You'll find a sample of what this file will look like in `.env.example`

- IMPORTANT: MAKE SURE YOU'D DONT EXPOSE THE KEYS YOU PUT IN THIS `.env` FILE. By that, I mean don't push them to a public repo, and please try to keep them keys you use in development not associated with any real funds. 

1. Set your `MUMBAI_RPC_URL` [environment variable.](https://www.twilio.com/blog/2017/01/how-to-set-environment-variables.html)

You can get one for free from [Chainlist](https://chainlist.org/?testnets=true&search=polygon). This is your connection to the blockchain, copy your RPC URL and paste in `MUMBAI_RPC_URL`. 

2. Set your `PRIVATE_KEY` environment variable. 

This is your private key from your wallet, ie [MetaMask](https://metamask.io/). This is needed for deploying contracts to public networks.

![WARNING](https://via.placeholder.com/15/f03c15/000000?text=+) **WARNING** ![WARNING](https://via.placeholder.com/15/f03c15/000000?text=+)

When developing, it's best practice to use a Metamask that isn't associated with any real money. A good way to do this is to make a new browser profile (on Chrome, Brave, Firefox, etc) and install Metamask on that brower, and never send this wallet money.  

Don't commit and push any changes to .env files that may contain sensitive information, such as a private key! If this information reaches a public GitHub repository, someone can use it to check if you have any Mainnet funds in that wallet address, and steal them!

`.env` example:
```
MUMBAI_RPC_URL='www.avax-test/asdfadsfafdadf'
PRIVATE_KEY='abcdef'
```

For other networks, you can use different environment variables for your RPC URL and your private key. 

## 3. Migrate Smart Contracts

```bash
$ npx hardhat run src/solidity/scripts/deploy.js --network mumbai
```

`or`

```bash
$ npx hardhat run src/solidity/scripts/deploy.js --network localhost
```

## 4. Run test

```bash
$ npx hardhat test
```