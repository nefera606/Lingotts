pragma solidity ^0.4.8;

//Here DIP and KYC information is stored
contract AccountId  {
  bool public active;
  string public userName;
  address public userAddress;
  mapping (address => bool) public safeAccounts;

  modifier onlyIfActive() {
    if(!active)
      revert();

    _;
  }

  modifier onlyIfOwner() {
    if(msg.sender != userAddress)
      revert();

    _;
  }

  function AccountId(string _userName, address _userAddress) {
    userName = _userName;
    userAddress = _userAddress;
    active = true;
  }

  function addSafeAccount(address account) onlyIfOwner {
    safeAccounts[account] = true;
  }

  function removeSafeAccount(address account) onlyIfOwner {
    safeAccounts[account] = false;
  }

  function activate() onlyIfOwner {
    active = true;
  }

  function deactivate() onlyIfOwner {
    active = false;
  }

}
