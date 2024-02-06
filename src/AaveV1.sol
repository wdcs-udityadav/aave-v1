// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@aave-protocol/contracts/lendingpool/LendingPoolCore.sol";
import "@aave-protocol/contracts/configuration/LendingPoolAddressesProvider.sol";

contract AaveV1 {
    LendingPoolAddressesProvider public constant provider =
        LendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    LendingPool public constant pool = LendingPool(provider.getLendingPool());

    function deposit(address _reserve, uint256 _amount) external {
        IERC20(_reserve).approve(pool.getLendingPoolCore(), _amount);

        pool.deposit(_token, _amount, 0);
    }

    function useAsCollateral(address _reserve) external {
        pool.setUserUseReserveAsCollateral(_reserve, true);
    }

    function borrow(address _reserve, uint256 _amount, uint256 _interestRateMode) external {
        pool.borrow(_reserve, _amount, _interestRateMode, 0);
    }

    function repay(address _reserve, uint256 _amount, address _behalfOf) external {
        IERC20(_reserve).approve(provider.getLendingPoolCore(), _amount);

        pool.repay(_reserve, _amount, _behalfOf);
    }
}
