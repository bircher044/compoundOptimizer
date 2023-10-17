// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "./interfaces/IComet.sol";

contract Loop is Ownable {
	address public comet;

	address public borrowableToken;
	address public supplyToken;
	address public immutable swapRouter;
	uint24 public immutable poolFee;

	error InvalidData(uint64 loops, uint256 supplyAmountsLength, uint256 borrowAmountsLength);

	constructor(
		address _swapRouter,
		address _comet,
		address _supplyToken,
		address _borrowableToken,
		uint24 _poolFee
	) Ownable(msg.sender) {
		swapRouter = _swapRouter;
		comet = _comet;
		supplyToken = _supplyToken;
		borrowableToken = _borrowableToken;
		poolFee = _poolFee;
	}

	function loop(uint64 loops, uint256[] memory supplyAmounts, uint256[] memory borrowAmounts) public onlyOwner {
		if (loops != supplyAmounts.length || loops != borrowAmounts.length) {
			revert InvalidData(loops, supplyAmounts.length, borrowAmounts.length);
		}
		IERC20(supplyToken).transferFrom(msg.sender, address(this), supplyAmounts[0]);

		for (uint64 i = 0; i < loops; i++) {
			supply(supplyToken, supplyAmounts[i]);
			borrow(borrowableToken, borrowAmounts[i]);
			swap(borrowableToken, supplyToken, IERC20(borrowableToken).balanceOf(address(this)), supplyAmounts[i]);
		}
	}

	function borrow(address token, uint256 amount) internal {
		Comet(comet).withdraw(token, amount);
	}

	function supply(address token, uint256 amount) internal {
		Comet(comet).supply(token, amount);
	}

	function swap(address token1, address token2, uint256 amountIn, uint256 amountOutMin) internal {
		ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
			tokenIn: token1,
			tokenOut: token2,
			fee: poolFee,
			recipient: msg.sender,
			deadline: block.timestamp,
			amountIn: amountIn,
			amountOutMinimum: amountOutMin,
			sqrtPriceLimitX96: 0
		});

		ISwapRouter(swapRouter).exactInputSingle(params);
	}
}
