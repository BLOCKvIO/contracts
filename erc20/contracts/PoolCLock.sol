
pragma solidity ^0.4.13;

import "./PoolAllocations.sol";

contract PoolCLock is PoolAllocations {

  uint256 public constant totalAmount = 911567810300063864980230061;

  function PoolCLock(ERC20Basic _token) PoolAllocations(_token) {
    
    // setup policy
    maxNumOfPayoutCycles = 5; // 20% * 5 = 100%
    startDay = now;
    cyclesStartsFrom = 1; // the first payout cycles is released immediately
    payoutCycleInDays = 2 minutes; //180 days; // 20% of tokens will be released every 6 months

    // allocations
    allocations[0x11B48d3179Eb448bcf6b7340B146E98DC44474Da] = createAllocationEntry(182313562060012772996046012, 0, 36462712412002554599209202, 2);
    allocations[0x878688D7350bc396E54f092acd440F9eB99cce10] = createAllocationEntry(182313562060012772996046012, 0, 36462712412002554599209202, 2);
    allocations[0xb726bF40BEBf5fDde6916C75927235F9631227A7] = createAllocationEntry(182313562060012772996046012, 0, 36462712412002554599209202, 2);
    allocations[0x133914a31c0450e131211bB0558BD50465e8C39e] = createAllocationEntry(182313562060012772996046012, 0, 36462712412002554599209202, 2);
    allocations[0x73eD2009d0f7da0A9d40568eEF3840393471E8b9] = createAllocationEntry(182313562060012772996046013, 0, 36462712412002554599209202, 3);
  }
}
