// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    address nFTMinterAddress;

    constructor(address nFTMinterAddress_) ERC721 ("KryptoBirdz", "KBIRDZ"){
        nFTMinterAddress = nFTMinterAddress_;
    }

    function mintToken(string memory tokenURI) public returns(uint256){
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _tetTokenURI(newItemId, tokenURI);
        setApprovalForAll(nFTMinterAddress, true);
        return newItemId;
    }

    
}