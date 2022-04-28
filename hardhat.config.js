require("@nomiclabs/hardhat-waffle");
require('dotenv').config()
const projectId = process.env.PROJECT_ID

module.exports = {
  defaultNetwork: 'hardhat',
  networks:{
    hardhat:{
      chainId: 1337
    },
    rinkeby:{
      url:`https://rinkeby.infura.io/v3/${projectId}`,
      accounts:[]
    },
  },
  solidity:{
    settings:{
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
};
