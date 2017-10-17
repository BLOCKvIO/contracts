
pragma solidity ^0.4.13;

import "./zeppelin-solidity/contracts/token/ERC20Basic.sol";
import "./zeppelin-solidity/contracts/math/SafeMath.sol";

contract TimelockD {

  // ERC20 basic token contract being held
  ERC20Basic token;

  // beneficiary of tokens after they are released
  address beneficiary;

  // timestamp where token release is enabled
  uint releaseTime;

  // percent to be released after 3 years
  uint8 percentOfFirstRelease = 50;

  bool firstRelease = false;

  // total amount of locked tokens
  uint256 totalAmount;

  // amount of tokens be released after 3 years
  uint256 amountOfFirstRelease;

  function TimelockD(ERC20Basic _token, uint256 _totalAmount, address _beneficiary) {
    token = _token;
    beneficiary = _beneficiary;
    releaseTime = now + 3 years;
    totalAmount = _totalAmount;

    amountOfFirstRelease = SafeMath.div(SafeMath.mul(_totalAmount, percentOfFirstRelease), 100); 
  }

  /**
   * @dev beneficiary claims tokens held by time lock
   */
  function claim() {
    require(msg.sender == beneficiary);
    require(now >= releaseTime);

    uint256 amount = token.balanceOf(this);

    uint256 tokenAmount = 0;
    if (!firstRelease) {
        tokenAmount = amountOfFirstRelease; 
        firstRelease = true; 
    } else {

        tokenAmount = SafeMath.div(amountOfFirstRelease, 36);
    }

    require(amount >= tokenAmount);
    releaseTime = now + 30 days;
    assert(token.transfer(beneficiary, tokenAmount));
  }
}