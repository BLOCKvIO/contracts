
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

    /** 
    // pool B
    allocations[0xD0AF9f75EA618163944585bF56aCA98204d0AB66] =   25;

    // pool C
    allocations[0xD0AF9f75EA618163944585bF56aCA98204d0AB66] =   25;

    // pool D
    allocations[0xD0AF9f75EA618163944585bF56aCA98204d0AB66] =   25;
    */
  }

  /**
   * @dev claims tokens held by time lock
   */
  function claim() {
    require(now >= releaseTime);
    require(allocations[msg.sender] != 0);

    var amount = allocations[msg.sender];
    allocations[msg.sender] = 0;

    token.transfer(msg.sender, amount);
  }
}