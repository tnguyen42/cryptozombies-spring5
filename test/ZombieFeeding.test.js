const { ethers } = require("hardhat");
require("chai").should();

describe("ZombieFeeding smart contract", () => {
  let ZombieFeeding;
  let zombieFeeding;
  let user1;
  let user2;

  beforeEach(async () => {
    [user1, user2] = await ethers.getSigners();
    ZombieFeeding = await ethers.getContractFactory("ZombieFeeding");
    zombieFeeding = await ZombieFeeding.deploy();
  });

  it("A user should be able to feed his own zombie", async () => {
    await zombieFeeding.connect(user1).createRandomZombie("Johnny Depp");
    await zombieFeeding.connect(user1).feedAndMultiply(0, 11111111111, "human");
    const zombieCount = (await zombieFeeding.getZombies()).length;

    zombieCount.should.equal(2);
  });

  it("A user should not be able to feed another user's zombie", async () => {
    await zombieFeeding.connect(user1).createRandomZombie("Amber Heard");

    await zombieFeeding
      .connect(user2)
      .feedAndMultiply(0, 111111111111111, "human")
      .should.be.revertedWith("You don't own this zombie");
  });

  it("The dna of a new zombie should end with 99 if created from a kitty", async () => {
    await zombieFeeding.connect(user1).createRandomZombie("Johnny Depp");
    await zombieFeeding.connect(user1).feedAndMultiply(0, 11111111111, "kitty");

    const newZombie = (await zombieFeeding.getZombies())[1];
    (newZombie.dna % 100).should.equal(99);
  });
});
