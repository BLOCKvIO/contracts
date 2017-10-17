
pragma solidity ^0.4.13;

import "./zeppelin-solidity/contracts/token/ERC20Basic.sol";

contract TimelockTable {

  // ERC20 basic token contract being held
  ERC20Basic token;

  // timestamp where token release is enabled
  uint releaseTime;

 // allocations map
  mapping (address => uint256) allocations;

  function TimelockTable(ERC20Basic _token, uint _releaseTime) {
    require(_releaseTime > now);
    token = _token;
    releaseTime = _releaseTime;

    allocations[0xFba09655dE6FCb113A1733Cf980d58a9b226e031] = 25;
    allocations[0x77373d8bfD31D25102237F9A8D2d838d25707782] = 1000;
  }

  /**
   * @dev claims tokens held by time lock
   */
  function claim() {
    require(now >= releaseTime);
    require(allocations[msg.sender] != 0);

    var amount = allocations[msg.sender];
    allocations[msg.sender] = 0;

    assert(token.transfer(msg.sender, amount));
  }
}