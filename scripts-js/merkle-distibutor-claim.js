const hre = require("hardhat");
const data = require("./accounts.json");
const merkleroot = require("./root.json");
const ethers = hre.ethers;
const { wrap_get, verify } = require('./merkle-proof-scripts.js');

async function main() {
    [ a1, a2 ,a3, a4 ] = await ethers.getSigners();
    const MerkToken = await ethers.getContractFactory("MerkleCoin");
    const merkAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
    const merk = new ethers.Contract(merkAddress, MerkToken.interface, a1);

    const Distributor = await ethers.getContractFactory("MerkleDistributor");
    const distAddress = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";
    const dist = new ethers.Contract(distAddress, Distributor.interface, a1);

    const proof = wrap_get(2);
    console.log(proof);

    const veri = verify(merkleroot, proof, 2);
    console.log(veri);

    // const balance = await merk.balanceOf(data.address[1]);
    // console.log("Initial Balance: ", balance.toString());
    
    // await dist.claim(2, data.address[0], data.amount[1], proof);

    // const balance1 = await merk.balanceOf(data.address[1]);
    // console.log("Final Balance: ", balance1.toString());

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });