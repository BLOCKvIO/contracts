
pragma solidity ^0.4.13;

import "./PoolAllocations.sol";

contract PoolDLock is PoolAllocations {

  uint256 public constant totalAmount = 546940686180038318988138036;

  function PoolDLock(ERC20Basic _token) PoolAllocations(_token) {
    
    // setup policy
    maxNumOfPayoutCycles = 36; // total * .5 / 36
    startDay = now + 3 years;  // first release date
    cyclesStartsFrom = 0;
    payoutCycleInDays = 30 days; // 1/36 of tokens will be released every month

    // allocations
    allocations[0xf194f110b720d000AEed91De3AB3d05DD4f27AB2] = createAllocationEntry(
      546940686180038318988138036, // total
      273470343090019159494069018, // first release
      7596398419167198874835250,   // next release
      18                           // the rest
    );
  }
}
