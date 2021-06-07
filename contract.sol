pragma solidity 0.5.16;
/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev Initializes the contract setting the deployer as the initial owner.
   */
  constructor () internal {
    address msgSender = msg.sender;
    _owner = msg.sender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  /**
   * @dev Returns the address of the current owner.
   */
  function owner() public view returns (address) {
    return _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(_owner == msg.sender, "Ownable: caller is not the owner");
    _;
  }

  /**
   * @dev Leaves the contract without owner. It will not be possible to call
   * `onlyOwner` functions anymore. Can only be called by the current owner.
   *
   * NOTE: Renouncing ownership will leave the contract without an owner,
   * thereby removing any functionality that is only available to the owner.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   * Can only be called by the current owner.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

contract saveHash is Ownable {
  
  /// 
  
  mapping (address  => bool)  private _addressAllowed ; 
  string [] private _hashTable ; 
  
  event newHash(string hash); 
  
  modifier onlyAllowed(){
      require (_addressAllowed[msg.sender] == true, "You are not allowed to use this function"); 
      _; 
  }
  
  modifier isValidHash(string memory hash){
      require (bytes(hash).length == 64, "Hash is not valid") ; 
      _; 
  }
  
  function addAddressToAllowed(address newAddress) external onlyOwner() returns (bool){
      _addressAllowed[newAddress] = true ; 
      return true; 
  }
  
  function removeAddressToAllowed(address addressToRemove) external onlyOwner() returns (bool){
      _addressAllowed[addressToRemove] = false ; 
      return true; 
  }
  
  function getAddressAllowed (address addressToVerify) external view returns (bool){
      return _addressAllowed[addressToVerify] ; 
  }
  
  function addHash (string calldata hash) external isValidHash(hash) onlyAllowed() returns (bool){
      _hashTable.push(hash); 
      emit newHash(hash); 
      return true ; 
  }
  
  function verifyHash(string calldata hash) external view isValidHash(hash) returns (bool){
      for (uint i = 0 ; i < _hashTable.length ; i++){
          if (keccak256(bytes(_hashTable[i])) == keccak256(bytes(hash))){
              return true ; 
          }
      }
      return false ; 
  }
  
  function getHashTableLength() external view returns (uint256){
      return _hashTable.length ; 
  }
  
  function getHash(uint256 i) external view returns (string memory){
      return _hashTable[i]; 
  }
  
  constructor() public {
      _addressAllowed[msg.sender] = true ; 
  }
  
  ///

}
