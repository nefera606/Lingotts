pragma solidity ^0.4.11;

import "./AccountId.sol";
import "./ERC223_token.sol";

// Per country
contract AccountIdFactory {

  struct Account {
    string username;
    address id;
    bool deleted;
  }

  address public tokenAddress;

  Account[] public accountList;

  mapping(bytes32 => bool) public existsAccount; // username
  mapping(bytes32 => uint) accounts; // username to index

  event NewAccount(string username, address id);

  function AccountIdFactory(string firstUser, uint tokenAmmount) {
    create(firstUser);
    tokenAddress = new ERC223Token(tokenAmmount);
  }

  // Creates and registers a new ID if it's not already created
  function create(string username)
    returns(address accountAddress)
  {

    if(!existsAccount[sha3(username)]) {
      accountAddress = new AccountId(username, msg.sender);

      register(username, accountAddress);
    } else {
      accountList[accounts[sha3(username)]].deleted = false;

      accountAddress = getAccount(username).id;
    }

    NewAccount(username, accountAddress);
  }

  // Logical deletion
  /*function remove(string username)  { ADD MODIFIER to allow only if sender is the owner of the contract beign deleted
    accountList[accounts[sha3(username)]].deleted = true;
  }*/

  // Returns an accountId if exists and has not been deleted. 0x0... otherwise
  function getAccountId(string username) constant returns(address id) {
    if(existsAccount[sha3(username)] && !getAccount(username).deleted)
      id = getAccount(username).id;
    else
      id = address(0);
  }

  // Number of elements in the AccountList array
  function getNumAccounts() constant returns(uint) {
    return accountList.length;
  }

  // Registers a new ID
  function register(string _username, address accountAddress) internal {
    accountList.push(Account({
      username: _username,
      id: accountAddress,
      deleted: false
    }));

    accounts[sha3(_username)] = accountList.length - 1;
    existsAccount[sha3(_username)] = true;
  }

  function getAccount(string username) internal constant returns(Account) {
    return accountList[accounts[sha3(username)]];
  }
}
