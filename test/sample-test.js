const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("KBMarket", function () {
  // beforeEach(async () => {

  // });

  it("Should mint and trade NFTs", async function () {
    const Market = await ethers.getContractFactory('KBMarket');
    const market = await Market.deploy();
    await market.deployed();
    let listingPrice = await market.getListingPrice();
    listingPrice = listingPrice.toString();

    const NFT = await ethers.getContractFactory('NFT');
    const nft = await NFT.deploy(market.address);
    await nft.deployed();

    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

    const auctionPrice = ethers.utils.parseUnits('100', 'ether');

    await nft.mintToken('https-t1');
    await nft.mintToken('https-t2');
    console.log(1);
    await market.makeMarketItem(nft.address, 1, auctionPrice, { value: listingPrice });
    console.log(2);
    await market.makeMarketItem(nft.address, 2, auctionPrice, { value: listingPrice });
    console.log(3);

    await market.connect(addr1).createMarketSale(nft.address, 1, {
      value: auctionPrice
    });
    console.log(4);

    const items = await market.fetchMarketTokens();
    console.log(5);

    console.log('items', items)
  });
});
