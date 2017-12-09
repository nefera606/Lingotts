pragma solidity ^0.4.4;

import "MultiOwned.sol";

contract Attributes is MultiOwned{

  //Data structures
  struct Attribute {
    string name;
    string value;
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

  modifier documentInRange(uint document) {
      if(document >= _numDocuments)
        revert();
      _;
  }

  //Events
  event ev_newAttribute(address indexed owner, string name, uint id);
  event ev_newValidation(address indexed validator, uint indexed id, uint expirationDate);
  event ev_requestAcces(address indexed who);


  // number of elements in the mapping
  uint public _numAttributes;
  uint public _numValidations;

  //Mappings
  mapping (uint => Attribute) public _attributes; // Link between attribute ID and its struct
  mapping (uint => Validation) public _validations;

  //Constructor
  function Attributes (){

  }

  //New information input
  function newAttribute (string name) onlyOwners{
    _attributes[_numAttributes].name = name;
    _numAttributes++;
    ev_newAttribute(msg.sender, name, _numAttributes-1);
  }

  function newValidation (uint expirationDate, uint attributeId, uint documentId) onlyOwners{
    _validations[_numValidations].timestamp = expirationDate;
    _validations[_numValidations].by = msg.sender;
    _attributes[attributeId].numValidations++;
    _attributes[attributeId].validations.push(_numValidations);
    attach(attributeId, documentId);
    ev_newValidation(msg.sender, attributeId, expirationDate);
    _numValidations++;
  }
  //request
  function requestAcces (){

  }

  //Getters
  function getAttributeName(uint attributeId) constant returns (string) {
    return _attributes[attributeId].name;
  }

  function getValidationFromAttribute(uint attributeId, uint index) constant returns (uint) {
    return _attributes[attributeId].validations[index];
  }
}
