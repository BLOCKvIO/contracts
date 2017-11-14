
pragma solidity ^0.4.13;

import "./zeppelin-solidity/contracts/token/ERC20Basic.sol";
import "./zeppelin-solidity/contracts/math/SafeMath.sol";

contract PoolDLock {

  // ERC20 basic token contract being held
  ERC20Basic token;

  // beneficiary of tokens after they are released
  address beneficiary;

  // first release date
  uint startDay = now + 3 years;

  // after the first release
  uint payoutCyclesLeft = 36;

  // after the first release
  uint constant payoutCycleInDays = 30 days;

  // number of payout cycles after the first release
  uint constant maxNumOfPayoutCycles = 36;

  // first release flag
  bool isFirstRelease = true;

  // total amount of locked tokens
  uint256 public constant totalAmount = 546940686180038280753511132;

  uint256 public constant firstReleaseTokens = 273470343090019140376755566;

  // amount of tokens to be released after 3 years 36 payout cycles - 1 month delay
  uint256 public constant nextReleasesTokens = 7596398419167198343798765;

  // the rest of division = (totalAmount * .5) / 36 should be added to the first release
  uint256 public constant restOfTokens = 26;

  function PoolDLock(ERC20Basic _token, address _beneficiary) {
    token = _token;
    beneficiary = _beneficiary;
  }

  /**
   * @dev beneficiary claims tokens held by time lock
   */
  function claim() {
    require(msg.sender == beneficiary);
    require(payoutCyclesLeft > 0);
    require(now >= startDay);

    uint256 tokens = 0;
    uint cycles = getPayoutCycles();
    if (isFirstRelease) {
      isFirstRelease = false;
      tokens = getFirstReleaseTokens(cycles);
    } else {

      require(cycles > 0);
      tokens = nextReleasesTokens * cycles;
    }

    payoutCyclesLeft -= cycles;

    assert(token.transfer(beneficiary, tokens));
  }

  function getFirstReleaseTokens(uint cycles) private returns (uint256) {
     uint256 r = firstReleaseTokens;

     if (cycles > 0) {
        r += nextReleasesTokens * cycles;
     }

     return r + restOfTokens;
  }

  function getPayoutCycles() private returns (uint) {
      uint cycles = uint((now - startDay) / payoutCycleInDays) + 1;

      if (cycles > maxNumOfPayoutCycles) {
          cycles = maxNumOfPayoutCycles;
      }

      return cycles - (maxNumOfPayoutCycles - payoutCyclesLeft);
  }
}
