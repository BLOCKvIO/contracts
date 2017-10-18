pragma solidity ^0.4.13;


import "./zeppelin-solidity/contracts/token/StandardToken.sol";
import "./zeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "./zeppelin-solidity/contracts/math/SafeMath.sol";
import "./Timelock.sol";
import "./TimelockTable.sol";
import "./TimelockD.sol";

/**
 * @title Blockv Token
 * @dev ERC20 Blockv Token (VEE)
 *
 * VEE Tokens are divisible by 1e8 (100,000,000) base
 * units referred to as 'Grains'.
 *
 * VEE are displayed using 8 decimal places of precision.
 *
 * 1 VEE is equivalent to:
 *   100000000 == 1 * 10**8 == 1e8 == One Hundred Million Grains
 *
 * 1 Billion VEE (total supply) is equivalent to:
 *   100000000000000000 == 1000000000 * 10**8 == 1e17 == One Hundred Quadrillion Grains
 *
 * All initial VEE Grains are assigned to the creator of
 * this contract.
 *
 */
contract BlockvToken is StandardToken, Pausable {

  string public constant name = 'BLOCKv Token';                          // Set the token name for display
  string public constant symbol = 'VEE';                                 // Set the token symbol for display
  uint8 public constant decimals = 8;                                    // Set the number of decimals for display

  uint8 constant releasedPercent = 35;
  uint8 constant lockPercentB = 25;
  uint8 constant lockPercentC = 25;
  uint8 constant lockPercentD = 15;
 
  uint256 public startingBlock;

  TimelockTable public tokenHolderB;
  Timelock public tokenHolderC;
  TimelockD public tokenHolderD;

  /**
   * @dev BlockvToken Constructor
   * Runs only on initial contract creation.
   */
  function BlockvToken(uint256 _initialAmount) {
    totalSupply = _initialAmount;                               // Set the total supply
    uint256 senderTokens = SafeMath.div(SafeMath.mul(_initialAmount, releasedPercent), 100);

    balances[msg.sender] = senderTokens;                      // Creator address is assigned all
    Transfer(0x0, msg.sender, senderTokens);

    startingBlock = block.number;                               // for all of our time based calculations (like vesting etc.)
  
    uint256 tokensPoolB = SafeMath.div(SafeMath.mul(_initialAmount, lockPercentB), 100);
    uint256 tokensPoolC = SafeMath.div(SafeMath.mul(_initialAmount, lockPercentC), 100);
    uint256 tokensPoolD = SafeMath.div(SafeMath.mul(_initialAmount, lockPercentD), 100);

    tokenHolderB = new TimelockTable(this);
    tokenHolderC = new Timelock(this, tokensPoolC, 0xFba09655dE6FCb113A1733Cf980d58a9b226e031);
    tokenHolderD = new TimelockD(this, tokensPoolD, 0xFba09655dE6FCb113A1733Cf980d58a9b226e031);

    balances[tokenHolderB] = tokensPoolB;
    balances[tokenHolderC] = tokensPoolC;
    balances[tokenHolderD] = tokensPoolD;

    Transfer(0x0, tokenHolderB, tokensPoolB);
    Transfer(0x0, tokenHolderC, tokensPoolC);
    Transfer(0x0, tokenHolderD, tokensPoolD);
  }

  /**
   * @dev Transfer token for a specified address when not paused
   * @param _to The address to transfer to.
   * @param _value The amount to be transferred.
   */
  function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
    require(_to != address(0));
    return super.transfer(_to, _value);
  }

  /**
   * @dev Transfer tokens from one address to another when not paused
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
    require(_to != address(0));
    return super.transferFrom(_from, _to, _value);
  }

  /**
   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) whenNotPaused returns (bool) {
    return super.approve(_spender, _value);
  }

  function () {
        //if ether is sent to this address, send it back.
        revert();
  }
}
