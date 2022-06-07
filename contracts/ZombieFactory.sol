// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract ZombieFactory {
  event NewZombie(uint256 zombieId, string name, uint256 dna);

  uint256 public dnaDigits = 16;
  uint256 public dnaModulus = 10**dnaDigits;

  struct Zombie {
    string name;
    uint256 dna;
  }

  Zombie[] public zombies;

  /**
   * @dev Creates a new zombie with the given name and DNA.
   * @param _name The name of the zombie.
   * @param _dna The DNA of the zombie.
   */
  function _createZombie(string memory _name, uint256 _dna) private {
    zombies.push(Zombie(_name, _dna));

    emit NewZombie(zombies.length - 1, _name, _dna);
  }

  /**
   * @dev Generate a random DNA from a name.
   * @param _str The name of the zombie.
   * @return The DNA of the zombie.
   */
  function _generateRandomDna(string memory _str)
    private
    view
    returns (uint256)
  {
    uint256 rand = uint256(keccak256(abi.encode(_str)));

    return rand % dnaModulus;
  }

  /**
   * @dev A public function to create a new random zombie.
   * @param _name The name of the zombie.
   */
  function createRandomZombie(string memory _name) public {
    uint256 randDna = _generateRandomDna(_name);
    _createZombie(_name, randDna);
  }
}
