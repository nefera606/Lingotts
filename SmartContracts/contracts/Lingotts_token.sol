pragma solidity ^0.4.11;

import './ERC223_interface.sol';
import './ERC223_receiving_contract.sol';
import './SafeMath.sol';

/**
 * @title Reference implementation of the ERC223 standard token.
 */
contract Lingotts is ERC223Interface {
    using SafeMath for uint;

    mapping(address => uint) balances; // List of user balances.
    uint public totalSupply;
    uint public avaiableSupply;
    uint public profits;
    bool public profitsAvaiable;

    event WeiSent(address sender, uint amount);
    event ProfitsClaimable(string message);

    function Lingotts(uint _totalSupply) {
      totalSupply = _totalSupply;
      avaiableSupply = _totalSupply;
      profitsAvaiable = false;
      //balances[msg.sender] = balances[msg.sender].add(totalSupply);
    }

    function makeProfitsAvaiable() { //MAKE ONLY CREATOR OR IN TIME
      profitsAvaiable = true;
      profits = this.balance - totalSupply;
      totalSupply = totalSupply + profits;
      ProfitsClaimable('The profits are claimable');
    }

    function claimProfits(){
      if (profitsAvaiable){
        uint percentage = (balances[msg.sender]*100)/(totalSupply+profits);
        balances[msg.sender].add(percentage.mul(profits));
      }
    }

    function() payable {
      WeiSent(msg.sender, msg.value);
    }

    /**
     * @dev Receives wei and adds the correct ammount of tokens to the sender's address.
     *      Deducts the sent tokens from the total supply of tokens
     *      Right now one wei is one token
     *
     * @param _value    ammount of wei to send.
     */
    function getTokensFromWei(uint _value) payable{
      if (_value > avaiableSupply){
        revert();
      }
      this.transfer(_value);
      balances[msg.sender].add(_value);
      avaiableSupply.sub(_value);
    }
    /**
     * @dev Receives tokens and adds the correct ammount of wei to the sender's address.
     *      adds the sent tokens to the total supply of tokens
     *      Right now one wei is one token
     *
     * @param _value    ammount of wei to send.
     */
    function getWeiFromToken(uint _value) payable{
      if (_value > balances[msg.sender]){
        revert();
      }
      balances[msg.sender].sub(_value);
      msg.sender.transfer(_value);
      avaiableSupply.add(_value);
    }

    /**
     * @dev Transfer the specified amount of tokens to the specified address.
     *      Invokes the `tokenFallback` function if the recipient is a contract.
     *      The token transfer fails if the recipient is a contract
     *      but does not implement the `tokenFallback` function
     *      or the fallback function to receive funds.
     *
     * @param _to    Receiver address.
     * @param _value Amount of tokens that will be transferred.
     * @param _data  Transaction metadata.
     */
    function transfer(address _to, uint _value, bytes _data) {
        // Standard function transfer similar to ERC20 transfer with no _data .
        // Added due to backwards compatibility reasons.
        if (_value > balances[msg.sender]){
          revert();
        }
        uint codeLength;

        assembly {
            // Retrieve the size of the code on target address, this needs assembly .
            codeLength := extcodesize(_to)
        }
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        if(codeLength>0) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(msg.sender, _value, _data);
        }
        Transfer(msg.sender, _to, _value, _data);
    }

    /**
     * @dev Transfer the specified amount of tokens to the specified address.
     *      This function works the same with the previous one
     *      but doesn't contain `_data` param.
     *      Added due to backwards compatibility reasons.
     *
     * @param _to    Receiver address.
     * @param _value Amount of tokens that will be transferred.
     */
    function transfer(address _to, uint _value) {
      if (_value > balances[msg.sender]){
        revert();
      }
        uint codeLength;
        bytes memory empty;

        assembly {
            // Retrieve the size of the code on target address, this needs assembly .
            codeLength := extcodesize(_to)
        }

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        if(codeLength>0) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(msg.sender, _value, empty);
        }
        Transfer(msg.sender, _to, _value, empty);
    }

    function emulateProfits(uint _value) payable{
      this.transfer(_value);
    }

    /**
     * @dev Returns balance of the `_owner`.
     *
     * @param _owner   The address whose balance will be returned.
     * @return balance Balance of the `_owner`.
     */
    function balanceOf(address _owner) constant returns (uint balance) {
        return balances[_owner];
    }
}
