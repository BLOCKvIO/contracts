pragma solidity ^0.4.13;

import "./zeppelin-solidity/contracts/ownership/Ownable.sol";

import "./BlockvToken.sol";
import "./BlockvPublicLedger.sol";

contract PoolAContract is Ownable {
    uint256 private ledgerContractSize = 0;
    uint256 public currentIndex = 0;
    uint public chunkSize = 0;

    bool public done = false;

    uint decimals = 18;

    uint256 tokenMultiplier = 10 ** 8;
    // 69164622576285.06170802 * tokenMultiplier
    uint256 public oneTokenInWei = 6916462257628506170802;

    uint defaultDiscount = 100;
    uint256 discountMultiplier = 10 ** 13;
    mapping(uint8 => uint256) discounts;

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
        // percent * discountMultiplier
        discounts[1] = 778486932785652;
        discounts[2] = 80 * discountMultiplier;
        discounts[3] = 90 * discountMultiplier;
        discounts[100] = 100 * discountMultiplier;
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

    function getTokenAmount(uint256 amount, uint8 discountGroup) private constant returns(uint256) {
        uint256 discount = getTokenDiscount(discountGroup);
        return amount * tokenMultiplier * 10 ** decimals / (oneTokenInWei * discount / 100 / discountMultiplier);
    }

    function getTokenDiscount(uint8 discount) private constant returns(uint256) {
        uint r = discounts[discount];
        if (r != 0) {
            return r;
        }
        
        return defaultDiscount * discountMultiplier;
    }
}