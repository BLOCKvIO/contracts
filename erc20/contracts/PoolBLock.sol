
pragma solidity ^0.4.13;

import "./PoolAllocations.sol";

contract PoolBLock is PoolAllocations {

  uint256 public constant totalAmount = 911567810300063864980230061;

  function PoolBLock(ERC20Basic _token) PoolAllocations(_token) {

    // setup policy
    maxNumOfPayoutCycles = 5; // 20% * 5 = 100%
    startDay = now;
    cyclesStartsFrom = 1; // the first payout cycles is released immediately
    payoutCycleInDays = 180 days; // 20% of tokens will be released every 6 months

    // allocations
    allocations[0xc499C241F2357a1a9fA5145231a5C2c4F51cC506] = createAllocationEntry(182313562060012772996046012, 0, 36462712412002554599209202, 2);
    allocations[0xDa5598BaE852A767343a65b8bB5Aa2A035DB0Df3] = createAllocationEntry(182313562060012772996046012, 0, 36462712412002554599209202, 2);
    allocations[0x768D9F044b9c8350b041897f08cA77AE871AeF1C] = createAllocationEntry(182313562060012772996046012, 0, 36462712412002554599209202, 2);
    allocations[0xb96De72d3fee8c7B6c096Ddeab93bf0b3De848c4] = createAllocationEntry(182313562060012772996046012, 0, 36462712412002554599209202, 2);
    allocations[0x6CFA1A9CB5C94087f418B3cA45338e5Fd9c511B9] = createAllocationEntry(182313562060012772996046013, 0, 36462712412002554599209202, 3);
  }
}
