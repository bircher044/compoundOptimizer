// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface Comet is IERC20 {
    /**
     * @dev Note: Does not accrue interest first
     * @param utilization The utilization to check the supply rate for
     * @return The per second supply rate at `utilization`
     */
    function getSupplyRate(uint utilization) external view returns (uint64);

    /**
     * @dev Note: Does not accrue interest first
     * @return The utilization rate of the base asset
     */
    function getUtilization() external view returns (uint);

    /**
     * @notice Withdraw an amount of asset from the protocol
     * @param asset The asset to withdraw
     * @param amount The quantity to withdraw
     */
    function withdraw(address asset, uint amount) external;

    /**
     * @notice Supply an amount of asset to the protocol
     * @param asset The asset to supply
     * @param amount The quantity to supply
     */
    function supply(address asset, uint amount) external;
}
