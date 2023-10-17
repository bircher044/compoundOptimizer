// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Loop.sol";

contract LoopFactory {
	mapping(address => address[]) public leverages;

	function createLeverage(
		address swapRouter,
		address comet,
		address supplyToken,
		address borrowableToken,
		uint64 loops,
		uint256[] memory supplyAmounts,
		uint256[] memory withdrawAmounts,
		uint24 poolFee
	) external {
		Loop loop = new Loop(swapRouter, comet, supplyToken, borrowableToken, poolFee);
		IERC20(supplyToken).transfer(address(loop), supplyAmounts[0]);
		leverages[msg.sender].push(address(loop));
	}
}
