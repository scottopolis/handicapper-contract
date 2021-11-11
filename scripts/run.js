const main = async () => {
  const [owner, randomPerson, rando2] = await hre.ethers.getSigners();

  const scoreContractFactory = await hre.ethers.getContractFactory("Handicapper");
  const scoreContract = await scoreContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await scoreContract.deployed();
  console.log("Contract deployed to:", scoreContract.address);

  /*
   * Get Contract balance
   */
  let contractBalance = await hre.ethers.provider.getBalance(
    scoreContract.address
  );
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let txn = await scoreContract.submitScore("Tijeras Creek", 84, "04/08/1981", 100, 99);
  await txn.wait();

  /*
   * Get Contract balance to see what happened!
   */
  contractBalance = await hre.ethers.provider.getBalance(scoreContract.address);
  console.log(
    'Contract balance:',
    hre.ethers.utils.formatEther(contractBalance)
  );

  let scores = await scoreContract.getAllScores();
  console.log("all scores", scores);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
