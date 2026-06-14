require("@nomicfoundation/hardhat-ethers");

/**
 * SafeSplit Hardhat config.
 * chainId 31337 = the value MetaMask uses for the "SafeSplit Local" network.
 */
module.exports = {
  solidity: "0.8.24",
  networks: {
    // In-process node started by `hardhat node`.
    hardhat: {
      chainId: 31337,
    },
    // Target used by deploy script (`--network localhost`) against the running node.
    localhost: {
      url: "http://127.0.0.1:8545",
      chainId: 31337,
    },
  },
};
