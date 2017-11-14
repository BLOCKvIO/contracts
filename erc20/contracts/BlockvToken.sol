pragma solidity ^0.4.13;


import "./zeppelin-solidity/contracts/token/StandardToken.sol";
import "./zeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "./zeppelin-solidity/contracts/math/SafeMath.sol";

import "./PoolBLock.sol";
import "./PoolCLock.sol";
import "./PoolDLock.sol";

/**
 * @title Blockv Token
 * @dev ERC20 Blockv Token (VEE)
 *
 * VEE Tokens are divisible by 1e8 (100,000,000) base
 * units referred to as 'Grains'.
 *
 * VEE are displayed using 18 decimal places of precision.
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

  string public constant name = "BLOCKv Token"; // Set the token name for display
  string public constant symbol = "VEE";        // Set the token symbol for display
  uint8  public constant decimals = 18;         // Set the number of decimals for display

  PoolBLock public poolBLock;
  PoolCLock public poolCLock;
  PoolDLock public poolDLock;

  uint256 constant totalAmountOfTokens = 3646271241200255205023407547;
  uint256 constant amountOfTokensPoolA = 1276194934420089321758192641;
  uint256 constant amountOfTokensPoolB = 911567810300063801255851886;
  uint256 constant amountOfTokensPoolC = 911567810300063801255851886;
  uint256 constant amountOfTokensPoolD = 546940686180038280753511132;

  address constant beneficiaryOfPoolC = 0x11B48d3179Eb448bcf6b7340B146E98DC44474Da;
  address constant beneficiaryOfPoolD = 0xa6EE2adb545939A39f90FD0C67De5b040d89EA32;

  // migration
  address public migrationMaster;
  address public migrationAgent;
  uint256 public totalMigrated;
  event Migrate(address indexed _from, address indexed _to, uint256 _value);

  /**
   * @dev BlockvToken Constructor
   * Runs only on initial contract creation.
   */
  function BlockvToken(address _migrationMaster) {
    require(_migrationMaster != 0);
    migrationMaster = _migrationMaster;

    totalSupply = totalAmountOfTokens; // Set the total supply

    balances[msg.sender] = amountOfTokensPoolA;
    Transfer(0x0, msg.sender, amountOfTokensPoolA);
  
    // time-locked tokens
    poolBLock = new PoolBLock(this);
    poolCLock = new PoolCLock(this, beneficiaryOfPoolC);
    poolDLock = new PoolDLock(this, beneficiaryOfPoolD);

    balances[poolBLock] = amountOfTokensPoolB;
    balances[poolCLock] = amountOfTokensPoolC;
    balances[poolDLock] = amountOfTokensPoolD;

    Transfer(0x0, poolBLock, amountOfTokensPoolB);
    Transfer(0x0, poolCLock, amountOfTokensPoolC);
    Transfer(0x0, poolDLock, amountOfTokensPoolD);
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

  /**
  * Token migration support:
  */

  /** 
  * @notice Migrate tokens to the new token contract.
  * @dev Required state: Operational Migration
  * @param _value The amount of token to be migrated
  */
  function migrate(uint256 _value) external {
    require(migrationAgent != 0);
    require(_value != 0);
    require(_value <= balances[msg.sender]);

    balances[msg.sender] = balances[msg.sender].sub(_value);
    totalSupply = totalSupply.sub(_value);
    totalMigrated = totalMigrated.add(_value);
    MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
    
    Migrate(msg.sender, migrationAgent, _value);
  }

  /**
  * @dev Set address of migration target contract and enable migration process.
  * @param _agent The address of the MigrationAgent contract
  */
  function setMigrationAgent(address _agent) external {
    require(_agent != 0);
    require(migrationAgent == 0);
    require(msg.sender == migrationMaster);

    migrationAgent = _agent;
  }

  function setMigrationMaster(address _master) external {
    require(_master != 0);
    require(msg.sender == migrationMaster);

    migrationMaster = _master;
  }
}

/**
* @title Migration Agent interface
*/
interface MigrationAgent {
  function migrateFrom(address _from, uint256 _value);
}
