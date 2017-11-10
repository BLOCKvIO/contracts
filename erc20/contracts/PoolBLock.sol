
pragma solidity ^0.4.13;

import "./zeppelin-solidity/contracts/token/ERC20Basic.sol";
import "./zeppelin-solidity/contracts/math/SafeMath.sol";

contract PoolBLock {

  uint maxNumOfPayoutCycles = 5;

  uint startDay = now;

  uint payoutCycleInDays = 180 days;

  // lock entry
  struct lockEntry {
      uint256 totalAmount;
      uint256 amount;
      uint numPayoutCycles;
  }

  // ERC20 basic token contract being held
  ERC20Basic token;

 // allocations map
  mapping (address => lockEntry) public allocations;

  function PoolBLock(ERC20Basic _token) {
    token = _token;

    allocations[0xa6EE2adb545939A39f90FD0C67De5b040d89EA32] = createAllocationEntry(500000);
    allocations[0x11B48d3179Eb448bcf6b7340B146E98DC44474Da] = createAllocationEntry(200000);
    allocations[0x655be1c8938588498bB2dabFa6c73D56854Bb6Ca] = createAllocationEntry(1000000);
  }

  /**
   * @dev claims tokens held by time lock
   */
  function claim() {
    var elem = allocations[msg.sender];

    require(elem.numPayoutCycles > 0);

    uint cycles = getPayoutCycles(elem.numPayoutCycles);
    require(cycles > 0);

    uint256 tbr = elem.amount * cycles;

    uint256 amount = token.balanceOf(this);
    require(amount >= tbr);

    elem.numPayoutCycles -= cycles;

    assert(token.transfer(msg.sender, tbr));
  }

  function getPayoutCycles(uint payoutCyclesLeft) private returns (uint) {
    uint cycles = uint((now - startDay) / payoutCycleInDays) + 1;

    if (cycles > maxNumOfPayoutCycles) {
       cycles = maxNumOfPayoutCycles;
    }

    return cycles - (maxNumOfPayoutCycles - payoutCyclesLeft);
  }

  function createAllocationEntry(uint256 totalAmount) private returns(lockEntry) {
    return lockEntry(totalAmount,
                     SafeMath.div(totalAmount, maxNumOfPayoutCycles),
                     maxNumOfPayoutCycles);
  }
}
