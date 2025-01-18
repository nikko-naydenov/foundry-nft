// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    //Errors
    error MoodNft__CantFlipNoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_happySvgImageUrl;
    string private s_sadSvgImageUrl;
    mapping(uint256 => string) private s_tokenIdToUri;
    mapping(uint256 => Mood) private s_toeknIdToMood;

    enum Mood {
        HAPPY,
        SAD
    }

    constructor(string memory happySvgImageUrl, string memory sadSvgImageUrl) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_happySvgImageUrl = happySvgImageUrl;
        s_sadSvgImageUrl = sadSvgImageUrl;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_toeknIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function _baseURI() internal view override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI;

        if(s_toeknIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUrl;
        } else if(s_toeknIdToMood[tokenId] == Mood.SAD) {
            imageURI = s_sadSvgImageUrl;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            name(),
                            '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                            '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    function flipMood(uint256 tokenId) public {
        if(!_isApprovedOrOwner(msg.sender, tokenId)) {
            revert MoodNft__CantFlipNoodIfNotOwner();
        }
        Mood mood = s_toeknIdToMood[tokenId];

        if(mood == Mood.HAPPY) {
            s_toeknIdToMood[tokenId] = Mood.SAD;
        } else if(mood == Mood.SAD) {
            s_toeknIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) private view returns (bool) {
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender);
    }
}
