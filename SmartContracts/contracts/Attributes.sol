pragma solidity ^0.4.4;

import "./MultiOwned.sol";

contract Attributes is MultiOwned{

  //Data structures
  struct Attribute {
    address owner;
    string name;
    address stored;//Address to be consulted
    uint numValidations;
    Validation[] validations;
  }

  struct Validation {
    uint timestamp;
    address by;
  }

  //Modifiers
  modifier attributeInRange(uint attribute) {
      if(attribute >= _numAttributes)
        revert();
      _;
  }

  //Events
  event ev_newAttribute(address indexed owner, string name, uint id);
  event ev_newValidation(address indexed validator, uint indexed id);

  // number of elements in the mapping
  uint public _numAttributes;

  //Mappings
  mapping (uint => Attribute) public _attributes; // Link between attribute ID and its struct

  //Constructor
  function Attributes (){
  }

  //New information input
  function newAttribute (string name, address storedAt) onlyUsers{
    _attributes[_numAttributes].owner = msg.sender;
    _attributes[_numAttributes].stored = storedAt;
    _attributes[_numAttributes].name = name;
    _numAttributes++;
    ev_newAttribute(msg.sender,
      name, _numAttributes-1);
  }

  function newValidation (uint attributeId, uint timestamp) onlyUsers{
    address _by = msg.sender;
    uint _time = timestamp;
    Validation _validation;
    _attributes[attributeId].numValidations++;
    _validation.by = _by;
    _validation.timestamp = _time;
    _attributes[attributeId].validations.push(_validation);
    ev_newValidation(msg.sender, attributeId);
  }

  //Getters
  function getAttributeName(uint attributeId) constant returns (string) {
    return _attributes[attributeId].name;
  }

  function getValidationsFromAttribute(uint attributeId) constant returns (uint) {
    return _attributes[attributeId].numValidations;
  }

  function getValidationData(uint attributeID, uint validationId) constant returns(uint, address){
    return (_attributes[attributeID].validations[validationId].timestamp, _attributes[attributeID].validations[validationId].by);
  }
}
