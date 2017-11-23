# BLOCKv Ethereum Smart Contract System

This repo contains all smart contract source code of the BLOCKv Ethereum smart contract system. The code is written in solidity and leverages the [OpenZeppelin](https://openzeppelin.org/) framework. 

## Objectives
The contracts have been built to implement BLOCKv's VEE ERC20 compliant token.
In addition, logic has been put in place to fulfill the promises of BLOCKv's TGE.
In the token distribution process, all tokens fell into one of the following categories:

* Pool A: 35% of all tokens, distributed to the TGE contributors.
* Pool B: 25% of all tokens, reserved for the company, early contributors and advisors
* Pool C: 25% of all tokens, reserved to incentivize the development community
* Pool D: 15% of all tokens, locked for 6 years to fuel future innovation and ecosystem health

The above pools follow different vesting periods. 
Pool A: no vesting, Pool B and C: vesting over a period of 2 years, 1/5th vestable after distribution, the remaining 4/5ths become vestable after 6 month lock up periods over two years. Pool D: vesting begins after three years whereby 1/36th becomes vestable every month.

In addition, the contract system was implemented to allow for the two step process during the Token sale phase, i. e. a) accrue contributions and b) calculate to be distributed token amounts once all parameters were fixed (token price, discount allocation). For that purpose, all contributions were recorded in a separate smart contract (BlockvPublicLedger), which was used to calculate the token amounts to be distributed by the Pool A category of the VEE token smart contract system.

## Further references
The address of the BLOCKv token contract on the Ethereum block chain is: xxxx
Details can be seen here: [Etherscan](https://etherscan.io/token/VEE)
A complete audit report of the BLOCKv source code can be found in the audit folder of this repo.
