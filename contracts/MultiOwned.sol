pragma solidity ^0.4.8;

contract MultiOwned {

  mapping (address => bool) public master;
  uint public numMasters;

  mapping (address => bool) public users;
  uint public numUsers;

  //Events
  event NewUser (address who, address by);
  event NewMaster(address who, address by);

  //modifier
  modifier onlyMaster() {
    if(!master[msg.sender])
      revert();
    _;
  }
  modifier onlyUsers() {
    if(!users[msg.sender])
      revert();
    _;
  }

  //functions
  function MultiOwned (){
    master[msg.sender] = true;
  }

  function addMaster(address who) onlyMaster {
    master[who] = true;
    numMasters++;
    NewMaster(who, msg.sender);
  }

  function removeMaster(address who) onlyMaster {
    master[who] = false;
    numMasters--;
  }

  function addUser(address wallet) onlyMaster {
    users[wallet] = true;
    numUsers++;
    NewUser(wallet, msg.sender);
  }

  function removeUser(address wallet) onlyMaster {
    users[wallet] = false;
    numUsers--;
  }

}
