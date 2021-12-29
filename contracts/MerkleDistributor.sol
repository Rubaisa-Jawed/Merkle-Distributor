//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

contract MerkleDistributor {
    address public token;
    bytes32 public merkleRoot;

    mapping(uint => uint) private claimedBitMap;

    event Claimed(uint index, address account, uint amount);

    constructor(address _token, bytes32 _merkleRoot) {
        token = _token;
        merkleRoot = _merkleRoot;
    }

    function isClaimed(uint index) public view returns (bool) {
        uint claimedWordIndex = index / 256;
        uint claimedBitIndex = index % 256;
        uint claimedWord = claimedBitMap[claimedWordIndex];
        uint mask = (1 << claimedBitIndex);
        return claimedWord & mask == mask;
    }

    function _setCLaimed(uint index) private {
        uint claimedWordIndex = index / 256;
        uint claimedBitIndex = index % 256;
        claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
    }

    function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
        bytes32 computedHash = leaf;

        for (uint i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (computedHash <= proofElement) {
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
            }
        }
        return computedHash == root;
    }

    function claim(uint index, address account, uint amount, bytes32[] calldata merkleProof) external {
        require(!isClaimed(index), "MerkleDistributor: Drop already claimed.");

        bytes32 node = keccak256(abi.encodePacked(index, account, amount));
        require(verify(merkleProof, merkleRoot, node), "MerkleDistributor: Invalid Proof.");

        _setCLaimed(index);
        require(IERC20(token).transfer(account, amount), "MerkleDistributor: Transfer failed.");

        emit Claimed(index, account, amount);
    }
}