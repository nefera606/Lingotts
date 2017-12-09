pragma solidity ^0.4.8;

import "./VTNUserManager.sol";

contract VTNUser  {

  VTNUserManager public userManager;
  address public userManagerAddress = 0xEB1e2c19bd833b7f33F9bd0325B74802DF187935;
  address public owner;
  string public userName;
  uint public tokents;

  modifier onlyUser() {
    if(userList[users[sha3(userName)]].blkAddress != msg.sender)
      revert();
    _;)
  }

  function VTNUser( string _userName) {
    userName = _userName;
    userManager = UserManager()//TODO: Automate this deployment
  }
}
