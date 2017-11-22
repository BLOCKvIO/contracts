
pragma solidity ^0.4.13;

import "./PoolAllocations.sol";

contract PoolDLock is PoolAllocations {

  uint256 public constant totalAmount = 546940686180038280753511066;

  function PoolDLock(ERC20Basic _token) PoolAllocations(_token) {
    
    // setup policy
    maxNumOfPayoutCycles = 36; // total * .5 / 36
    startDay = now + 3 years;  // first release date
    cyclesStartFrom = 0;
    payoutCycleInDays = 30 days; // 1/36 of tokens will be released every month

    // allocations
    allocations[0x4311F6F65B411f546c7DD8841A344614297Dbf62] = createAllocationEntry(
      182313562060012760251170355, // total
      91156781030006380125585177,  // first release
      2532132806389066114599588,   // next release
      10                           // the rest
    );
     allocations[0x3b52Ab408cd499A1456af83AC095fCa23C014e0d] = createAllocationEntry(
      182313562060012760251170355, // total
      91156781030006380125585177,  // first release
      2532132806389066114599588,   // next release
      10                           // the rest
    );
     allocations[0x728D5312FbbdFBcC1b9582E619f6ceB6412B98E4] = createAllocationEntry(
      182313562060012760251170356, // total
      91156781030006380125585177,  // first release
      2532132806389066114599588,   // next release
      11                           // the rest
    );
  }
}
