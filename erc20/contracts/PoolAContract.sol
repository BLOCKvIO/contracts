pragma solidity ^0.4.13;

import "./zeppelin-solidity/contracts/ownership/Ownable.sol";

import "./BlockvToken.sol";
import "./BlockvPublicLedger.sol";

contract PoolAContract is Ownable {
    uint256 private ledgerContractSize = 0;
    uint256 public currentIndex = 0;
    uint public chunkSize = 0;

    bool public done = false;

    uint256 public conversionRate;
    uint8 public tokenPrice;

    address public ledgerContractAddr;
    address public blockVContractAddr;

    BlockvToken blockVContract;
    BlockvPublicLedger ledgerContract; 

    function PoolAContract(address _ledgerContractAddr, address _blockVContractAddr, uint _chunkSize, uint256 _conversionRate, uint8 _tokenPrice) {
        ledgerContractAddr = _ledgerContractAddr;
        blockVContractAddr = _blockVContractAddr;

        chunkSize = _chunkSize;
        conversionRate = _conversionRate;
        tokenPrice = _tokenPrice;

        blockVContract = BlockvToken(_blockVContractAddr);
        ledgerContract = BlockvPublicLedger(_ledgerContractAddr);

        ledgerContractSize = ledgerContract.distributionEntryCount();
    }

    function distribution() onlyOwner {
        require(!done);

        uint256 i = currentIndex;
        for (; i < currentIndex + chunkSize && i < ledgerContractSize; i++) {
            var (, to, amount, discount, ) = ledgerContract.distributionList(i);
            uint256 tokenAmount = getTokenAmount(amount, discount);
            assert(blockVContract.transfer(to, tokenAmount)); 
        }
        currentIndex = i;   

        if (currentIndex == ledgerContractSize) {
          done = true;
        }
    }

    function setChunkSize(uint _chunkSize) onlyOwner {
        chunkSize = _chunkSize;
    }

    function getTokenAmount(uint256 amount, uint8 discount) private returns(uint256) {
        return (amount * conversionRate * 100) / (tokenPrice * discount / 100);
    }
}