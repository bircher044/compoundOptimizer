// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/IERC20.sol";
import "./interfaces/IComet.sol";

contract Loop is Ownable {
    IComet public comet;
    IERC20 public borrowableToken;
    IERC20 public supplyToken;

    error InvalidData(uint64 loops, uint64 supplyAmountsLength, uint64 borrowAmountsLength);

    constructor(
        address _iToken,
        address _supplyToken,
        address _borrowableToken,
        uint64 loops,
        uint256[] memory supplyAmounts,
        uint256[] memory borrowAmounts
    ) Ownable(msg.sender) {
        if (loops != supplyAmounts) {
            revert InvalidData(loops, supplyAmounts.length, borrowAmounts.length);
        }

        comet = IComet(_iToken);
        supplyToken = IERC20(_supplyToken);
        borrowableToken = IERC20(_borrowableToken);
        loop();
    }

    function loop(uint64 loops, uint256 supplyAmount, uint256 borrowAmount) internal {
        loops--;
        supply(supplyToken, supplyAmount);
        borrow(borrowToken);
    }

    function borrow(address token, uint256 amount) internal {
        comet.withdraw(token, amount);
    }

    function supply(address token, uint256 amount) internal {
        comet.supply(token, amount);
    }

    function swap(address token1, address token2, uint256 amountOutMin) internal {}
}
