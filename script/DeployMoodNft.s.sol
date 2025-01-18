// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {MoodNft} from "src/MoodNft.sol";

contract DeployMoodNft is Script {
    function run() external returns (MoodNft) {
        string memory happySvg = vm.readFile("img/dynamicNft/happy.svg");
        string memory sadSvg = vm.readFile("img/dynamicNft/sad.svg");

        vm.startBroadcast();
        MoodNft nftContract = new MoodNft(svgToImageURI(happySvg), svgToImageURI(sadSvg));
        vm.stopBroadcast();

        return nftContract;
    }

    function svgToImageURI(string memory svg) public  pure returns(string memory){
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));

        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }
}
