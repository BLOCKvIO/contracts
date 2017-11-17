
pragma solidity ^0.4.13;

import "./zeppelin-solidity/contracts/token/ERC20Basic.sol";
import "./zeppelin-solidity/contracts/math/SafeMath.sol";

contract PoolAllocations {

  // ERC20 basic token contract being held
  ERC20Basic token;

 // allocations map
  mapping (address => lockEntry) public allocations;

  // max number of payout cycles
  uint constant maxNumOfPayoutCycles = 5;

  // first release date
  uint startDay = now;

  uint constant payoutCycleInDays = 180 days;

   // total amount of locked tokens
  uint256 public constant totalAmount = 911567810300063864980230061;

  // lock entry
  struct lockEntry {
      uint256 totalAmount;
      uint256 amount;
      uint256 restOfTokens;
      bool isFirstRelease;
      uint numPayoutCycles;
  }

  function PoolAllocations(ERC20Basic _token) {
    token = _token;
  }

  /**
   * @dev claims tokens held by time lock
   */
  function claim() public {
    var elem = allocations[msg.sender];

    require(elem.numPayoutCycles > 0);

    uint cycles = getPayoutCycles(elem.numPayoutCycles);
    require(cycles > 0);

    uint256 tbr = elem.amount * cycles;

    if (elem.isFirstRelease) {
      tbr += elem.restOfTokens;
      elem.isFirstRelease = false;
    }

    elem.numPayoutCycles -= cycles;

    assert(token.transfer(msg.sender, tbr));
  }

  function getPayoutCycles(uint payoutCyclesLeft) private constant returns (uint) {
    uint cycles = uint((now - startDay) / payoutCycleInDays) + 1;

    if (cycles > maxNumOfPayoutCycles) {
       cycles = maxNumOfPayoutCycles;
    }

    return cycles - (maxNumOfPayoutCycles - payoutCyclesLeft);
  }

  function createAllocationEntry(uint256 totalAmount, uint256 amount, uint256 rest) internal returns(lockEntry) {
    return lockEntry(totalAmount, // total
                     amount, // amount
                     rest, // rest
                     true, //isFirstRelease
                     maxNumOfPayoutCycles); //payoutCyclesLeft
  }
}
