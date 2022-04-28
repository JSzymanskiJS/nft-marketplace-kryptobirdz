// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract KBMarket {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    Counters.Counter private _tokensSold;

    address payable owner;

    uint256 listingPrice = 0.045 ether;

    constructor() {
        owner = payable(msg.sender);
    }

    struct MarketToken {
        uint256 itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool isSold;
    }

    mapping(uint256 => MarketToken) private _idToMarketToken;

    event MarketTokenMinted(
        uint256 indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }

    function mintMarketItem(
        address nftContract,
        uint256 tokenId,
        uint256 price
    ) public payable nonReentrant {
        require(price > 0, "Price must be at least one wei.");
        require(
            msg.value == listingPrice,
            "Price must be equal to listing price."
        );

        _tokenIds.increment();
        uint256 itemId = _tokenIds.current();

        idToMarket[itemId] = MarketToken(
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender),
            payable(address(0)),
            price,
            false
        );

        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

        emit MarketTokenMinted(
            itemId,
            nftContract,
            tokenId,
            msg.sender,
            address(0),
            price,
            false
        );
    }

    function createMarketItems(address nftContract, uint256 itemId)
        public
        payable
        nonReentrant
    {
        uint256 price = _idToMarketToken[itemId].price;
        uint256 tokenId = _idToMarketToken[itemId].tokenURI;
        require(
            msg.value == price,
            "Please submit the asking price in order to continue."
        );
        _idToMarketToken[itemId].seller.trasfer(msg.value);
        IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);
        _idToMarketToken[itemId].owner = payable(msg.sender);
        _idToMarketToken[itemId].sold = true;
        _tokensSold.increment();

        payable(owner).transfer(listingPrice);
    }

    function fetchMarketTokens() public view returns (MarketToken[] memory) {
        uint256 itemCount = _tokenIds.current();
        uint256 unsoldItemsCount = itemCount - _tokensSold.current();
        uint256 currentIndex = 0;

        MarketToken[] memory items = new MarketToken[](unsoldItemsCount);
        for (uint256 i = 0; i < itemCount; i++) {
            uint256 currentId = i + 1;
            if (_idToMarketToken[currentId].owner == address(0)) {
                MarketToken storage currentItem = _idToMarketToken[currentId];
                items[currentIndex] = currentItem;
                currentItem += 1;
            }
        }
        return items;
    }

    function fetchMyNFTs() public view returns (MarketToken[] memory) {
        uint256 totalItemCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (_idToMarketToken[i + 1].owner == msg.sender) {
                itemCount += 1;
            }
        }
    }
}
