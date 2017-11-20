
pragma solidity ^0.4.13;

import "./zeppelin-solidity/contracts/token/ERC20Basic.sol";

contract PoolAllocations {

  // ERC20 basic token contract being held
  ERC20Basic token;

 // allocations map
  mapping (address => lockEntry) public allocations;

  // lock entry
  struct lockEntry {
      uint256 totalAmount;        // total amount of token for a user
      uint256 firstReleaseAmount; // amount to be released 
      uint256 nextRelease;        // amount to be released every month
      uint256 restOfTokens;       // the rest of tokens if not divisible
      bool isFirstRelease;        // just flag
      uint numPayoutCycles;       // only after 3 years
  }

  // max number of payout cycles
  uint maxNumOfPayoutCycles;

  // first release date
  uint public startDay;

  // defines how many of cycles should be released immediately
  uint cyclesStartFrom = 1;

  uint payoutCycleInDays;

  function PoolAllocations(ERC20Basic _token) public {
    token = _token;
  }

  /**
   * @dev claims tokens held by time lock
   */
  function claim() public {
    require(now >= startDay);

     var elem = allocations[msg.sender];
    require(elem.numPayoutCycles > 0);

    uint256 tokens = 0;
    uint cycles = getPayoutCycles(elem.numPayoutCycles);

    if (elem.isFirstRelease) {
      elem.isFirstRelease = false;
      tokens += elem.firstReleaseAmount;
      tokens += elem.restOfTokens;
    } else {
      require(cycles > 0);
    }

    tokens += elem.nextRelease * cycles;

    elem.numPayoutCycles -= cycles;

    assert(token.transfer(msg.sender, tokens));
  }

  function getPayoutCycles(uint payoutCyclesLeft) private constant returns (uint) {
    uint cycles = uint((now - startDay) / payoutCycleInDays) + cyclesStartFrom;

    if (cycles > maxNumOfPayoutCycles) {
       cycles = maxNumOfPayoutCycles;
    }

    return cycles - (maxNumOfPayoutCycles - payoutCyclesLeft);
  }

  function createAllocationEntry(uint256 total, uint256 first, uint256 next, uint256 rest) internal returns(lockEntry) {
    return lockEntry(total, // total
                     first, // first
                     next,  // next
                     rest,  // rest
                     true,  //isFirstRelease
                     maxNumOfPayoutCycles); //payoutCyclesLeft
  }
}
