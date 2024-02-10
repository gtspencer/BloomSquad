// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

import { ERC1155 } from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract BloomSquad is ERC1155, Ownable {
    string private _baseURI = "ipfs://bafybeicdwvru4rhggyxjoafbqjbobfabpy6d42en5jvywxucofgeqqk6hi/";
    mapping(uint256 => string) public tokenMetadata;
    mapping(uint256 => uint256) public tokenLimits;
    mapping(uint256 => uint256) public tokensMinted;

    constructor() ERC1155("ipfs://bafybeicdwvru4rhggyxjoafbqjbobfabpy6d42en5jvywxucofgeqqk6hi/{id}.json") {
        tokenMetadata[0] = "BloomSquadOG.json";

        tokenLimits[0] = 100;
    }

    function mint(uint256 tokenId, address to) external
    {
        require(tokensMinted[tokenId] < tokenLimits[tokenId], "No more tokens left");

        _mint(to, tokenId, 1, "");
        tokensMinted[tokenId]++;
    }

    function updateMetadata(uint256 tokenId, string memory metadata) external onlyOwner
    {
        tokenMetadata[tokenId] = metadata;
    }

    function increaseTokenLimit(uint256 tokenId, uint256 newLimit) external onlyOwner
    {
        require(tokenLimits[tokenId] < newLimit, "Cannot destroy tokens");

        tokenLimits[tokenId] = newLimit;
    }

    function baseURI() public view virtual returns (string memory)
    {
        return _baseURI;
    }

    function updateBaseURI(string memory newURI) external onlyOwner
    {
        _baseURI = newURI;
    }

    function uri(uint256 id) public view override returns (string memory)
    {
        string memory base = baseURI();
        return bytes(base).length > 0 ? string(abi.encodePacked(base, tokenMetadata[id])) : ""; 
    }
}