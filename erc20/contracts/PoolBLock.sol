
pragma solidity ^0.4.13;

import "./PoolAllocations.sol";

contract PoolBLock is PoolAllocations {

  uint256 public constant totalAmount = 911567810300063864980230061;

  function PoolBLock(ERC20Basic _token) PoolAllocations(_token) {

    // setup policy
    maxNumOfPayoutCycles = 5; // 20% * 5 = 100%
    startDay = now;
    cyclesStartFrom = 1; // the first payout cycles is released immediately
    payoutCycleInDays = 180 days; // 20% of tokens will be released every 6 months

    // allocations
    allocations[0x2f09079059b85c11DdA29ed62FF26F99b7469950] = createAllocationEntry(182313562060012772996046012, 0, 36462712412002554599209202, 2);
    allocations[0x3634acA3cf97dCC40584dB02d53E290b5b4b65FA] = createAllocationEntry(182313562060012772996046012, 0, 36462712412002554599209202, 2);
    allocations[0x768D9F044b9c8350b041897f08cA77AE871AeF1C] = createAllocationEntry(182313562060012772996046012, 0, 36462712412002554599209202, 2);
    allocations[0xb96De72d3fee8c7B6c096Ddeab93bf0b3De848c4] = createAllocationEntry(182313562060012772996046012, 0, 36462712412002554599209202, 2);
    allocations[0x2f97bfD7a479857a9028339Ce2426Fc3C62D96Bd] = createAllocationEntry(182313562060012772996046013, 0, 36462712412002554599209202, 3);
  }
}
