pragma solidity ^0.4.13;

import "./zeppelin-solidity/contracts/ownership/Ownable.sol";

import "./BlockvToken.sol";
import "./BlockvPublicLedger.sol";

contract PoolAContract is Ownable {
    uint256 private ledgerContractSize = 0;
    uint256 public currentIndex = 0;
    uint public chunkSize = 0;

    bool public done = false;

    uint multiplier = 10 ** 13;
    uint decimals = 8; // to be discussed

    // 69164622576285.7 * multiplier
    uint256 public oneTokenInWei = 691646225762857000000000000;

    uint defaultDiscount = 100;
    mapping(uint8 => uint) discounts;

    address public ledgerContractAddr;
    address public blockVContractAddr;

    BlockvToken blockVContract;
    BlockvPublicLedger ledgerContract; 

    function PoolAContract(address _ledgerContractAddr, address _blockVContractAddr, uint _chunkSize) {
        ledgerContractAddr = _ledgerContractAddr;
        blockVContractAddr = _blockVContractAddr;

        chunkSize = _chunkSize;

        blockVContract = BlockvToken(_blockVContractAddr);
        ledgerContract = BlockvPublicLedger(_ledgerContractAddr);

        ledgerContractSize = ledgerContract.distributionEntryCount();

        // init discounts
        // percent * multiplier
        discounts[1] = 778486932785652;
        discounts[2] = 80 * multiplier;
        discounts[3] = 90 * multiplier;
        discounts[100] = 100 * multiplier;
    }

    function distribution() public onlyOwner {
        require(!done);

        uint256 i = currentIndex;
        for (; i < currentIndex + chunkSize && i < ledgerContractSize; i++) {
            var (, to, amount, discount,) = ledgerContract.distributionList(i);
            uint256 tokenAmount = getTokenAmount(amount, discount);
            assert(blockVContract.transferFrom(msg.sender, to, tokenAmount));
        }
        currentIndex = i;   

        if (currentIndex == ledgerContractSize) {
          done = true;
        }
    }

    function setChunkSize(uint _chunkSize) public onlyOwner {
        chunkSize = _chunkSize;
    }

    function getTokenAmount(uint256 amount, uint8 discountGroup) private returns(uint256) {
        uint discount = getTokenDiscount(discountGroup);
        return amount * 10 ** decimals / (oneTokenInWei * discount) / 100 / multiplier;
    }

    function getTokenDiscount(uint8 discount) private returns(uint) {
        uint r = discounts[discount];
        if (r != 0) {
            return r;
        }
        
        return defaultDiscount * multiplier;
    }
}