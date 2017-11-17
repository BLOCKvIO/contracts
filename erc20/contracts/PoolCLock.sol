
pragma solidity ^0.4.13;

import "./zeppelin-solidity/contracts/token/ERC20Basic.sol";
import "./zeppelin-solidity/contracts/math/SafeMath.sol";

contract PoolCLock {

  // ERC20 basic token contract being held
  ERC20Basic token;

  // beneficiary of tokens after they are released
  address beneficiary;

  // first release date
  uint startDay = now;

  // max number of payout cycles = 20%
  uint constant maxNumOfPayoutCycles = 5;

  // number of payout cycles left
  uint payoutCyclesLeft = 5;

  // first release flag
  bool isFirstRelease = true;

  // cycle period in days
  uint constant payoutCycleInDays = 180 days;

  // total amount of locked tokens
  uint256 public constant totalAmount = 911567810300063864980230061;

  // tokens to be released every 6months
  uint256 public constant tokenToBeReleased = 182313562060012772996046012;

  // the rest of division = totalAmount / 5
  uint256 public constant restOfTokens = 1;

  function PoolCLock(ERC20Basic _token, address _beneficiary) {
    token = _token;
    beneficiary = _beneficiary;
  }

  /**
   * @dev beneficiary claims tokens held by time lock
   */
  function claim() {
    require(msg.sender == beneficiary);
    require(payoutCyclesLeft > 0);

    uint cycles = getPayoutCycles();
    require(cycles > 0);

    uint256 tbr = tokenToBeReleased * cycles;

    if (isFirstRelease) {
        isFirstRelease = false;
        tbr += restOfTokens;
    }

    payoutCyclesLeft -= cycles;

    assert(token.transfer(beneficiary, tbr));
  }

  function getPayoutCycles() private constant returns (uint) {
      uint cycles = uint((now - startDay) / payoutCycleInDays) + 1;

      if (cycles > maxNumOfPayoutCycles) {
          cycles = maxNumOfPayoutCycles;
      }

      return cycles - (maxNumOfPayoutCycles - payoutCyclesLeft);
  }
}
