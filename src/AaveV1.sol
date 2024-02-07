// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@aave-protocol/contracts/lendingpool/LendingPool.sol";
import "@aave-protocol/contracts/lendingpool/LendingPoolCore.sol";
import "@aave-protocol/contracts/configuration/LendingPoolAddressesProvider.sol";

contract AaveV1 {
    LendingPoolAddressesProvider public constant provider =
        LendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    LendingPool public pool = LendingPool(provider.getLendingPool());

    function deposit(address _reserve, uint256 _amount) external {
        IERC20(_reserve).approve(provider.getLendingPoolCore(), _amount);

        pool.deposit(_reserve, _amount, 0);
    }

    function useAsCollateral(address _reserve) external {
        pool.setUserUseReserveAsCollateral(_reserve, true);
    }

    function borrow(address _reserve, uint256 _amount) external {
        uint256 _interestRateMode = 1;
        pool.borrow(_reserve, _amount, _interestRateMode, 0);
    }

    function repay(address _reserve, uint256 _amount, address payable _behalfOf) external {
        IERC20(_reserve).approve(provider.getLendingPoolCore(), _amount);

        pool.repay(_reserve, _amount, _behalfOf);
    }

    function swapBorrowRateMode(address _reserve) external {
        pool.swapBorrowRateMode(_reserve);
    }

    function rebalanceStableRate(address _reserve, address _user) external {
        pool.rebalanceStableBorrowRate(_reserve, _user);
    }

    function getUserHealthFactor(address _user) public view returns (uint256 healthFactor) {
        (,,,,,,, healthFactor) = pool.getUserAccountData(_user);
    }

    function liquidationCall(
        address _collateral,
        address _reserve,
        address _user,
        uint256 _purchaseAmount,
        bool _receiveAToken
    ) external {
        require(getUserHealthFactor(_user) < 1, "Health factor < 1");
        IERC20(_reserve).approve(provider.getLendingPoolCore(), _purchaseAmount);

        pool.liquidationCall(_collateral, _reserve, _user, _purchaseAmount, _receiveAToken);
    }
}
