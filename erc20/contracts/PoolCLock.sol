
pragma solidity ^0.4.13;

import "./zeppelin-solidity/contracts/token/ERC20Basic.sol";
import "./zeppelin-solidity/contracts/math/SafeMath.sol";

contract PoolCLock {

  // ERC20 basic token contract being held
  ERC20Basic token;

  // beneficiary of tokens after they are released
  address beneficiary;

  uint startDay = now;

  uint maxNumOfPayoutCycles = 5;

  uint payoutCyclesLeft = 5;

  // timestamp where token release is enabled
  uint payoutCycleInDays = 180 days;

  // percent to be released every 6 months
  uint8 constant percentToBeReleased = 20;

  // total amount of locked tokens
  uint256 totalAmount;

  // tokens to be released every 6 months
  uint256 tokensToBeReleased;

  function PoolCLock(ERC20Basic _token, uint256 _totalAmount, address _beneficiary) {
    token = _token;
    beneficiary = _beneficiary;
    totalAmount = _totalAmount;

    tokensToBeReleased = SafeMath.div(SafeMath.mul(_totalAmount, percentToBeReleased), 100);
  }

  /**
   * @dev beneficiary claims tokens held by time lock
   */
  function claim() {
     require(msg.sender == beneficiary);
     uint cycles = getPayoutCycles();

     require(cycles > 0);

     uint256 tbr = tokensToBeReleased * cycles;

     uint256 amount = token.balanceOf(this);
     require(amount >= tbr);

     payoutCyclesLeft -= cycles;

    assert(token.transfer(beneficiary, tbr));
  }

  function getPayoutCycles() private returns (uint) {
      uint cycles = uint((now - startDay) / payoutCycleInDays) + 1;

      if (cycles > maxNumOfPayoutCycles) {
         cycles = maxNumOfPayoutCycles;
      }

      return cycles - (maxNumOfPayoutCycles - payoutCyclesLeft);
  }
}
