
pragma solidity ^0.4.13;

import "./zeppelin-solidity/contracts/token/ERC20Basic.sol";
import "./zeppelin-solidity/contracts/math/SafeMath.sol";

contract PoolBLock {

  // ERC20 basic token contract being held
  ERC20Basic token;

 // allocations map
  mapping (address => lockEntry) public allocations;

  // max number of payout cycles
  uint constant maxNumOfPayoutCycles = 5;

  // first release date
  uint startDay = now;

  uint constant payoutCycleInDays = 180 days;

   // total amount of locked tokens
  uint256 public constant totalAmount = 911567810300063864980230061;

  // lock entry
  struct lockEntry {
      uint256 totalAmount;
      uint256 amount;
      uint256 restOfTokens;
      bool isFirstRelease;
      uint numPayoutCycles;
  }

  function PoolBLock(ERC20Basic _token) {
    token = _token;

    allocations[0xc499C241F2357a1a9fA5145231a5C2c4F51cC506] = createAllocationEntry(182313562060012772996046012, 36462712412002554599209202, 2);
    allocations[0xDa5598BaE852A767343a65b8bB5Aa2A035DB0Df3] = createAllocationEntry(182313562060012772996046012, 36462712412002554599209202, 2);
    allocations[0x768D9F044b9c8350b041897f08cA77AE871AeF1C] = createAllocationEntry(182313562060012772996046012, 36462712412002554599209202, 2);
    allocations[0xb96De72d3fee8c7B6c096Ddeab93bf0b3De848c4] = createAllocationEntry(182313562060012772996046012, 36462712412002554599209202, 2);
    allocations[0x6CFA1A9CB5C94087f418B3cA45338e5Fd9c511B9] = createAllocationEntry(182313562060012772996046012, 36462712412002554599209202, 3);
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

    if (elem.isFirstRelease) {
      tbr += elem.restOfTokens;
      elem.isFirstRelease = false;
    }

    elem.numPayoutCycles -= cycles;

    assert(token.transfer(msg.sender, tbr));
  }

  function getPayoutCycles(uint payoutCyclesLeft) private constant returns (uint) {
    uint cycles = uint((now - startDay) / payoutCycleInDays) + 1;

    if (cycles > maxNumOfPayoutCycles) {
       cycles = maxNumOfPayoutCycles;
    }

    return cycles - (maxNumOfPayoutCycles - payoutCyclesLeft);
  }

  function createAllocationEntry(uint256 totalAmount, uint256 amount, uint256 rest) private returns(lockEntry) {
    return lockEntry(totalAmount, // total
                     amount, // amount
                     rest, // rest
                     true, //isFirstRelease
                     maxNumOfPayoutCycles); //payoutCyclesLeft
  }
}
