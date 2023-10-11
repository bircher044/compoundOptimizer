// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.20;

interface Comet {
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
}
