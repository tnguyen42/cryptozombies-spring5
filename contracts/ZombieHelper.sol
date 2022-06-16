// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./ZombieFeeding.sol";

contract ZombieHelper is ZombieFeeding {
  modifier aboveLevel(uint256 _level, uint256 _zombieId) {
    require(
      zombies[_zombieId].level >= _level,
      "Zombie is not above required level"
    );
    _;
  }

  function changeName(uint256 _zombieId, string calldata _newName)
    external
    aboveLevel(2, _zombieId)
  {
    require(msg.sender == zombieToOwner[_zombieId], "You are not the owner");
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint256 _zombieId, uint256 _newDna)
    external
    aboveLevel(2, _zombieId)
  {
    require(msg.sender == zombieToOwner[_zombieId], "You are not the owner");
    zombies[_zombieId].dna = _newDna;
  }

  function getZombiesByOwner(address _owner)
    external
    view
    returns (uint256[] memory)
  {
    uint256[] memory result = new uint256[](ownerZombieCount[_owner]);

    uint256 counter = 0;

    for (uint256 i = 0; i < zombies.length; i++) {
      if (zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }

    return result;
  }
}
