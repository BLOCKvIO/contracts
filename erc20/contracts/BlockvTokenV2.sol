pragma solidity ^0.4.13;

import "./zeppelin-solidity/contracts/token/StandardToken.sol";
import "./zeppelin-solidity/contracts/lifecycle/Pausable.sol";

contract BlockvTokenV2 is StandardToken, Pausable {

  string public constant name = 'BLOCKv Token';                          // Set the token name for display
  string public constant symbol = 'VEE';                                 // Set the token symbol for display
  uint8 public constant decimals = 8;                                    // Set the number of decimals for display

  address migrationAgent;

  /**
   * @dev BlockvToken Constructor
   * Runs only on initial contract creation.
   */
  function BlockvTokenV2(address _migrationAgent) {
    migrationAgent = _migrationAgent;
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

  // Migration related methods
  function createToken(address _target, uint256 _amount) {
    require(msg.sender == migrationAgent);

    balances[_target] = balances[_target].add(_amount);
    totalSupply = totalSupply.add(_amount);

    Transfer(migrationAgent, _target, _amount);
  }

  function finalizeMigration() {
    require(msg.sender == migrationAgent);
    migrationAgent = 0;
  }
}
