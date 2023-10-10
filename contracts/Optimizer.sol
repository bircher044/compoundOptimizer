// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";

contract Optimizer is ERC4626 {
    IERC20 public compoundUsdc;
    IERC20 public compoundUsdc_e;
    uint8 public position;

    constructor(
        string memory _name,
        string memory _symbol,
        address _compoundUsdc,
        address _compoundUsdc_e
    ) ERC4626(IERC20(_compoundUsdc)) ERC20(_name, _symbol) {
        compoundUsdc = IERC20(_compoundUsdc);
        compoundUsdc_e = IERC20(_compoundUsdc_e);
    }

    function getCurrentUnderlying() internal view returns (IERC20) {
        return position == 0 ? compoundUsdc : compoundUsdc_e;
    }

    function asset() public view override returns (address) {
        return address(getCurrentUnderlying());
    }

    function totalAssets() public view override returns (uint256) {
        return
            compoundUsdc.balanceOf(address(this)) +
            compoundUsdc_e.balanceOf(address(this));
    }

    function _deposit(
        address caller,
        address receiver,
        uint256 assets,
        uint256 shares
    ) internal override {
        SafeERC20.safeTransferFrom(
            getCurrentUnderlying(),
            caller,
            address(this),
            assets
        );
        _mint(receiver, shares);

        emit Deposit(caller, receiver, assets, shares);
    }

    function _withdraw(
        address caller,
        address receiver,
        address owner,
        uint256 assets,
        uint256 shares
    ) internal override {
        if (caller != owner) {
            _spendAllowance(owner, caller, shares);
        }

        _burn(owner, shares);
        SafeERC20.safeTransfer(getCurrentUnderlying(), receiver, assets);

        emit Withdraw(caller, receiver, owner, assets, shares);
    }
}
