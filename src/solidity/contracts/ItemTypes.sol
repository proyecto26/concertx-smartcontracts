// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract ItemTypes {
    struct Item {
        uint itemId;
        IERC721 nft;
        uint tokenId;
        uint currentPrice;
        uint previousPrice;
        address payable creator;
        address payable owner;
        uint createdAt;
        bool sold;
    }
}