const { expect } = require("chai");
const { ethers } = require("hardhat");
require("chai").should();

describe("ZombieFactory smart contract", () => {
  let ZombieFactory;
  let zombieFactory;

  beforeEach(async () => {
    ZombieFactory = await ethers.getContractFactory("ZombieFactory");
    zombieFactory = await ZombieFactory.deploy();
  });

  it("should create a new zombie", async () => {
    const initialZombieCount = (await zombieFactory.getZombies()).length;
    expect(initialZombieCount).to.equal(0);
    await zombieFactory.createRandomZombie("Johnny Depp");

    const zombieCount = (await zombieFactory.getZombies()).length;
    expect(zombieCount).to.equal(1);
  });
});
