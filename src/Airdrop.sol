// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {BitMaps} from "@openzeppelin/contracts/utils/structs/BitMaps.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

error InvalidProof();
error AlreadyClaimed();

contract Airdrop is ERC20 {
    using BitMaps for BitMaps.BitMap;
    bytes32 immutable merkleRoot;

    BitMaps.BitMap bitMap;
    constructor(bytes32 merkleRoot_) ERC20("TWO COIN", "TCN") {
        merkleRoot = merkleRoot_;
    }

    function claim(bytes32[] calldata proof, uint amount, uint index) external {
        bytes32 leaf = keccak256(abi.encode(msg.sender, index, amount));

        if (!MerkleProof.verify(proof, merkleRoot, leaf)) revert InvalidProof();
        if (bitMap.get(index)) revert AlreadyClaimed();

        bitMap.setTo(index, true);

        _mint(msg.sender, amount);
    }
}
