
pragma solidity ^0.4.13;

import "./zeppelin-solidity/contracts/token/ERC20Basic.sol";
import "./zeppelin-solidity/contracts/math/SafeMath.sol";

contract PoolDLock {

    // lock entry
  struct lockEntry {
      uint256 totalAmount; // total amount of token for a user
      uint256 firstReleaseAmount; // amount to be released after 3 years
      uint256 nextRelease; // amount to be released every month
      uint256 restOfTokens; // the rest of tokens if not divisible
      bool isFirstRelease; // just flag
      uint numPayoutCycles; // only after 3 years
  }

   // allocations map
  mapping (address => lockEntry) public allocations;

  // ERC20 basic token contract being held
  ERC20Basic token;

  // first release date
  uint startDay = now + 3 years;

  // after the first release
  uint constant payoutCycleInDays = 30 days;

  // number of payout cycles after the first release
  uint constant maxNumOfPayoutCycles = 36;

  // total amount of locked tokens
  uint256 public constant totalAmount = 546940686180038318988138036;


  function PoolDLock(ERC20Basic _token) {
    token = _token;

    allocations[0xf194f110b720d000AEed91De3AB3d05DD4f27AB2] = lockEntry(
      546940686180038318988138036, // total
      273470343090019159494069018, // first release
      7596398419167198874835250,   // next release
      18,                          // the rest
      true,                        // is first release
      maxNumOfPayoutCycles         // number of payout cycles
    );
  }

  /**
   * @dev beneficiary claims tokens held by time lock
   */
  function claim() {
    require(now >= startDay);

     var elem = allocations[msg.sender];
    require(elem.numPayoutCycles > 0);

    uint256 tokens = 0;
    uint cycles = getPayoutCycles(elem.numPayoutCycles);

    tokens += elem.nextRelease * cycles;

    if (elem.isFirstRelease) {
      elem.isFirstRelease = false;
      tokens += elem.firstReleaseAmount;
      tokens += elem.restOfTokens;
    }

    elem.numPayoutCycles -= cycles;

    assert(token.transfer(msg.sender, tokens));
  }

  function getPayoutCycles(uint payoutCyclesLeft) private returns (uint) {
      uint cycles = uint((now - startDay) / payoutCycleInDays);

      if (cycles > maxNumOfPayoutCycles) {
          cycles = maxNumOfPayoutCycles;
      }
      return cycles - (maxNumOfPayoutCycles - payoutCyclesLeft);
  }
}
