// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./ZombieFactory.sol";

interface KittyInterface {
  function getKitty(uint256 _id)
    external
    view
    returns (
      bool isGestating,
      bool isReady,
      uint256 cooldownIndex,
      uint256 nextActionAt,
      uint256 siringWithId,
      uint256 birthTime,
      uint256 matronId,
      uint256 sireId,
      uint256 generation,
      uint256 genes
    );
}

contract ZombieFeeding is ZombieFactory {
  KittyInterface public kittyContract;

  /**
   * @dev Redefines the kittyContract address.
   */
  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(block.timestamp + cooldownTime);
  }

  function _isReady(Zombie storage _zombie) internal view returns (bool) {
    return _zombie.readyTime <= block.timestamp;
  }

  function feedAndMultiply(
    uint256 _zombieId,
    uint256 _targetDna,
    string memory _species
  ) public {
    _feedAndMultiply(_zombieId, _targetDna, _species);
  }

  /**
   * @dev Feed a zombie that will create a new one
   * @param _zombieId The id of the zombie to feed
   * @param _targetDna The dna of the target
   * @param _species The species of the target
   */
  function _feedAndMultiply(
    uint256 _zombieId,
    uint256 _targetDna,
    string memory _species
  ) internal {
    require(
      msg.sender == zombieToOwner[_zombieId],
      "You don't own this zombie"
    );

    Zombie storage myZombie = zombies[_zombieId];

    require(_isReady(myZombie), "Zombie is not ready");

    _targetDna = _targetDna % dnaModulus;
    uint256 newDna = (myZombie.dna + _targetDna) / 2;

    if (keccak256(abi.encode(_species)) == keccak256(abi.encode("kitty"))) {
      newDna = newDna - (newDna % 100) + 99;
    }

    _createZombie("NoName", newDna);
    _triggerCooldown(myZombie);
  }

  /**
   * @dev Allows a zombie to feed on a kitty.
   * @param _zombieId The id of the zombie attacking.
   * @param _kittyId The id of the kitty being attacked.
   */
  function feedOnKitty(uint256 _zombieId, uint256 _kittyId) public {
    uint256 kittyDna;

    (, , , , , , , , , kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}
