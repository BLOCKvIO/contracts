module.exports = {
  networks: {
    testnet: {
      host: "ethereum1.watercoins.io",
      port: 8545,
      network_id: "*", // Match any network id
      from: "0x7AbcC9f43285C85E13868684b4d52842c3AEA49b",
      gas: 3000000
    },
    development: {
      //host: "ec2-34-201-82-129.compute-1.amazonaws.com",
      host: "localhost",
      port: 8545,
      network_id: "*", // Match any network id
      from: "0x7AbcC9f43285C85E13868684b4d52842c3AEA49b",
      gas: 3000000
    },
    local: {
      host: "localhost",
      port: 8546,
      network_id: "*", // Match any network id
      from: "0x285446a55199b48eb0a7d25f35979df5512d1fb5",
      gas: 3000000
    }
  }
};
