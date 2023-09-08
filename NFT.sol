// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
pragma experimental ABIEncoderV2;

import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721A, Ownable {
    string private baseTokenURI;
    uint256 public totalNFTs;

    address founderAddress;
    event BaseURIChanged(string baseURI);

    constructor(string memory baseURI) ERC721A("Collection", "NFT") {
        baseTokenURI = baseURI;
        founderAddress = msg.sender;       
        totalNFTs = 0;
    }
    
    //Settings

    function setFounder(address _newFounder) public onlyOwner {
        founderAddress = _newFounder;
    }

    //Mint

    function Mint() external payable onlyOwner {
        _safeMint(msg.sender, 50);
    }

    //NFT Metadata Methods

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory) 
    {
        string memory _tokenURI = super.tokenURI(tokenId);
        return string(abi.encodePacked(_tokenURI, ".json"));
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        baseTokenURI = baseURI;
        emit BaseURIChanged(baseURI);
    }

}

