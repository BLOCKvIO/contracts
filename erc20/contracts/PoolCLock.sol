
pragma solidity ^0.4.13;

import "./zeppelin-solidity/contracts/token/ERC20Basic.sol";
import "./zeppelin-solidity/contracts/math/SafeMath.sol";

contract PoolCLock {

  // ERC20 basic token contract being held
  ERC20Basic token;

  // beneficiary of tokens after they are released
  address beneficiary;

  // timestamp where token release is enabled
  uint releaseTime;

  // percent to be released every 6 months
  uint8 constant percentOfTokens = 20;

  // total amount of locked tokens
  uint256 totalAmount;

  // tokens to be released every 6 months
  uint256 tokensToBeReleased;

  // lock time in days
  uint constant releaseTimeDelay = 180 days;

  function PoolCLock(ERC20Basic _token, uint256 _totalAmount, address _beneficiary) {
    token = _token;
    beneficiary = _beneficiary;
    releaseTime = now;
    totalAmount = _totalAmount;

    tokensToBeReleased = SafeMath.div(SafeMath.mul(_totalAmount, percentOfTokens), 100);
  }

  /**
   * @dev beneficiary claims tokens held by time lock
   */
  function claim() {
    require(msg.sender == beneficiary);
    require(now >= releaseTime);

    uint256 amount = token.balanceOf(this);
    require(amount >= tokensToBeReleased);

    releaseTime = now + releaseTimeDelay;
    assert(token.transfer(beneficiary, tokensToBeReleased));
  }
}
