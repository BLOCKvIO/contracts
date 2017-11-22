
pragma solidity ^0.4.13;

import "./PoolAllocations.sol";

contract PoolCLock is PoolAllocations {

  uint256 public constant totalAmount = 911567810300063801255851777;

  function PoolCLock(ERC20Basic _token) PoolAllocations(_token) {
    
    // setup policy
    maxNumOfPayoutCycles = 5; // 20% * 5 = 100%
    startDay = now;
    cyclesStartFrom = 1; // the first payout cycles is released immediately
    payoutCycleInDays = 180 days; // 20% of tokens will be released every 6 months

    // allocations
    allocations[0x0d02A3365dFd745f76225A0119fdD148955f821E] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
    allocations[0x0deF4A4De337771c22Ac8C8D4b9C5Fec496841A5] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
    allocations[0x467600367BdBA1d852dbd8C1661a5E6a2Be5F6C8] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
    allocations[0x92E01739142386E4820eC8ddC3AFfF69de99641a] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
    allocations[0x1E0a7E0706373d0b76752448ED33cA1E4070753A] = createAllocationEntry(182313562060012760251170357, 0, 36462712412002552050234071, 2);
  }
}
