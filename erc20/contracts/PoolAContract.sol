pragma solidity ^0.4.13;

import "./zeppelin-solidity/contracts/ownership/Ownable.sol";

import "./BlockvToken.sol";
import "./BlockvPublicLedger.sol";

contract PoolAContract is Ownable {
    uint256 private ledgerContractSize = 0;
    uint256 public currentIndex = 0;
    uint public chunkSize = 0;

    bool public done = false;

    uint constant decimals = 18;

    uint256 public constant oneTokenInWei = 69164622576285;

    uint constant defaultDiscount = 100;
    uint256 constant discountMultiplier = 10 ** 24;
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
        discounts[1] = 78975612990889553132979286;
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
        return (amount * 10 ** decimals * discountMultiplier) / ((oneTokenInWei * discount) / 100);
    }

    function getTokenDiscount(uint8 discount) private constant returns(uint256) {
        uint r = discounts[discount];
        if (r != 0) {
            return r;
        }
        
        return defaultDiscount * discountMultiplier;
    }
}