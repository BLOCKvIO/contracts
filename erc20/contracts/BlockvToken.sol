pragma solidity ^0.4.13;


import "./zeppelin-solidity/contracts/token/StandardToken.sol";
import "./zeppelin-solidity/contracts/lifecycle/Pausable.sol";


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
  uint256 public constant decimals = 8;                                  // Set the number of decimals for display
  uint256 public constant initSupplyMultiplier = 1000000000;
  uint256 public constant INITIAL_SUPPLY = initSupplyMultiplier * 10**decimals;    // total amount of VEE specified in Grains
  uint256 public startingBlock;

  /**
  * here are the addresses of our ledger Contracts which provide the transfer/allowance mechanos
  * which are based on the TGE outcome.
  */ 
  string public constant poolALedger = '0x1f2218868faf2dfe7e7b475501423dc71430b1ad';
  string public constant poolBLedger = '';
  string public constant poolCLedger = '';
  string public constant poolDLedger = '';

  /**
  * here are the percentages of our 4 pools
  */ 
  uint256 public constant poolAPercentage = 35;
  uint256 public constant poolBPercentage = 25;
  uint256 public constant poolCPercentage = 25;
  uint256 public constant poolDPercentage = 15;

  /**
  * safety/require vars
  */ 
  bool public poolASetup = false; 
  bool public poolBSetup = false; 
  bool public poolCSetup = false; 
  bool public poolDSetup = false; 

  /**
  * structs needed for our pool payout rules
  */ 
  struct PayoutCycleDefinition {
    uint256 payoutBlock;
    uint percentToBeReleased;
  } 

  struct PayoutDefinition {
    uint256 amountTotal;
    uint256 amountLeft;
    address to;
  }

  struct PoolDefinition {
    uint PercentageOfSupply;
    uint NumPayoutCycles;
    PayoutCycleDefinition[] PayoutCycles;
    PayoutDefinition[] Payouts;
  }

  /**
  * finally, our pools
  */ 
  PoolDefinition[4] public pools;
   
  /**
   * @dev InitPool functions
   * Called only once by constructor
   */
  function initPoolA() internal {
    //only allow this to be called once
    require(poolASetup == false);

    // step 1: init the PoolDefinition
    PoolDefinition memory pool;
    PayoutCycleDefinition memory cycle;
    
    pool.PercentageOfSupply = poolAPercentage;
    pool.NumPayoutCycles = 1;
    
    cycle.payoutBlock = startingBlock;
    cycle.percentToBeReleased = 100;
    pool.PayoutCycles.push(cycle);

    // step 2: read the poolA ledger to init the payouts

    // we are done with initializing
    pools.push(pool);
    poolASetup = true;
  }

  /**
   * @dev BlockvToken Constructor
   * Runs only on initial contract creation.
   */
  function BlockvToken() {
    totalSupply = INITIAL_SUPPLY;                               // Set the total supply
    balances[msg.sender] = INITIAL_SUPPLY;                      // Creator address is assigned all
    startingBlock = block.number;                               // for all of our time based calculations (like vesting etc.)
                                                                // unsafe, but can be verified right after publishing as it is only set once
    initPoolA();
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

}
