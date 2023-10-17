// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IComet.sol";

contract Loop is Ownable {
	address public comet;
	address public borrowableToken;
	address public supplyToken;

	error InvalidData(uint64 loops, uint256 supplyAmountsLength, uint256 borrowAmountsLength);

	constructor(address _comet, address _supplyToken, address _borrowableToken) Ownable(msg.sender) {
		comet = _comet;
		supplyToken = _supplyToken;
		borrowableToken = _borrowableToken;
	}

	function loop(uint64 loops, uint256[] memory supplyAmounts, uint256[] memory borrowAmounts) public onlyOwner {
		if (loops != supplyAmounts.length || loops != borrowAmounts.length) {
			revert InvalidData(loops, supplyAmounts.length, borrowAmounts.length);
		}

		for (uint64 i = 0; i < loops; i++) {
			supply(supplyToken, supplyAmounts[i]);
			swap(borrowableToken, supplyToken, supplyAmounts[i]);
			borrow(borrowableToken, borrowAmounts[i]);
		}
	}

	function borrow(address token, uint256 amount) internal {
		Comet(comet).withdraw(token, amount);
	}

	function supply(address token, uint256 amount) internal {
		Comet(comet).supply(token, amount);
	}

	function swap(address token1, address token2, uint256 amountOutMin) internal {}
}
