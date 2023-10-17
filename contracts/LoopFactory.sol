// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Loop.sol";

contract LoopFactory {
	mapping(address => address[]) public activeLoops;

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
		loop.makeLoop(loops, supplyAmounts, withdrawAmounts);

		activeLoops[msg.sender].push(address(loop));
	}

	function removeLeverage(
		uint64 id,
		uint64 loops,
		uint256[] memory supplyAmounts,
		uint256[] memory withdrawAmounts
	) external {
		Loop(activeLoops[msg.sender][id]).removeLoop(loops, supplyAmounts, withdrawAmounts);
		removeActiveLoop(msg.sender, id);
	}

	function removeActiveLoop(address user, uint64 id) internal {
		for (uint i = id; i < activeLoops[user].length - 1; i++) {
			activeLoops[user][i] = activeLoops[user][i + 1];
		}
		activeLoops[user].pop;
	}
}
