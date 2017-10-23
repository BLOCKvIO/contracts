
pragma solidity ^0.4.13;

import "./zeppelin-solidity/contracts/token/ERC20Basic.sol";
import "./zeppelin-solidity/contracts/math/SafeMath.sol";

contract PoolBLock {

  // lock entry
  struct lockEntry {
      uint256 amount; // 20 % of total sum
      uint releaseTime;
      int8 numPayoutCycles; // times * amount = 100 %
  }

  // ERC20 basic token contract being held
  ERC20Basic token;

  uint constant releaseTimeDelay = 180 days;

 // allocations map
  mapping (address => lockEntry) allocations;

  function PoolBLock(ERC20Basic _token) {
    token = _token;

    allocations[0xFba09655dE6FCb113A1733Cf980d58a9b226e031] = lockEntry(25, now, 5);
    allocations[0x77373d8bfD31D25102237F9A8D2d838d25707782] = lockEntry(1000, now, 5);
  }

  /**
   * @dev claims tokens held by time lock
   */
  function claim() {
    var elem = allocations[msg.sender];

    require(now >= elem.releaseTime);
    require(elem.numPayoutCycles > 0);

    uint256 amount = token.balanceOf(this);
    require(amount >= elem.amount);

    elem.numPayoutCycles -= 1;
    elem.releaseTime = now + releaseTimeDelay;

    assert(token.transfer(msg.sender, elem.amount));
  }
}
