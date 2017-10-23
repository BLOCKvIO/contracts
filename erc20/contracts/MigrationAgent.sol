pragma solidity ^0.4.13;

import "./zeppelin-solidity/contracts/math/SafeMath.sol";
import "./zeppelin-solidity/contracts/ownership/Ownable.sol";

import "./BlockvToken.sol";
import "./BlockvTokenV2.sol";

contract MigrationAgentImpl is Ownable {

    // source 
    address public sourceToken;
    //target
    address public targetToken;

    uint256 tokenSupply;

    function MigrationAgentImpl(address _sourceToken) {
        owner = msg.sender;
        sourceToken = _sourceToken;
        tokenSupply = BlockvToken(sourceToken).totalSupply();
    }

    function setTargetToken(address _targetToken) onlyOwner {
        require(_targetToken != 0); //Allow this change once only
        targetToken = _targetToken;
    }

    //Interface implementation
    function migrateFrom(address _from, uint256 _value) {
        require(msg.sender == sourceToken);
        require(targetToken != 0);

        //Right here sourceToken has already been updated, but corresponding GNT have not been created in the targetToken contract yet
        safetyInvariantCheck(_value);

        BlockvTokenV2(targetToken).createToken(_from, _value);

        //Right here totalSupply invariant must hold
        safetyInvariantCheck(0);
    }

    function finalizeMigration() onlyOwner {
        safetyInvariantCheck(0);

        BlockvTokenV2(targetToken).finalizeMigration();

        sourceToken = 0;
        targetToken = 0;
        tokenSupply = 0;
    }

    function safetyInvariantCheck(uint256 _value) private {
        require(targetToken != 0);
        require(BlockvToken(sourceToken).totalSupply() + BlockvTokenV2(targetToken).totalSupply() == SafeMath.sub(tokenSupply, _value));
    }
}