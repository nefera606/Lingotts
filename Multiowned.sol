pragma solidity ^0.4.8;

contract MultiOwned {
  uint numOwners;
  mapping (address => bool) public owners;

  event NewOwner(address who, address by);
  event RemoveOwner(address who, address by);

  modifier onlyOwners() {
    if(!owners[msg.sender])
      revert();
    _;
  }

  function MultiOwned() {
    owners[msg.sender] = true;
    numOwners = 1;
  }

  function addOwner(address who) onlyOwners {
    owners[who] = true;
    numOwners++;

    NewOwner(who, msg.sender);
  }

  function removeOwner(address who) onlyOwners {
    if(numOwners == 1)
      revert();

    owners[who] = false;
    numOwners--;

    RemoveOwner(who, msg.sender);
  }
}
