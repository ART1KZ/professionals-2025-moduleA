// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import "./interfaces/IERC20.sol";

contract Pool {
    IERC20 public tokenA;
    IERC20 public tokenB;
    IERC20 public lpToken;

    uint256 public reserveA;
    uint256 public reserveB;

    uint256 public totalLiquidity;

    constructor(address _tokenA, address _tokenB, address _lpToken) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        lpToken = IERC20(_lpToken);
    }

    modifier validAddress(address _addr) {
        require(_addr != address(0), "Invalid address");
        _;
    }

    modifier validAmount(uint256 _amount) {
        require(_amount > 0, "Invalid amount");
        _;
    }

    function addLiquidity(uint256 _amountA, uint256 _amountB) public {
        tokenA.transferFrom(msg.sender, address(this), _amountA);
        tokenB.transferFrom(msg.sender, address(this), _amountB);

        uint256 liquidity;
        if (totalLiquidity == 0) {
            liquidity = _amountA + _amountB;
        } else {
            uint256 liquidityA = (_amountA * totalLiquidity) / reserveA;
            uint256 liquidityB = (_amountB * totalLiquidity) / reserveB;
            liquidity = liquidityA > liquidityB ? liquidityB : liquidityA;
        }

        reserveA += _amountA;
        reserveB += _amountB;
        totalLiquidity += liquidity;

        lpToken.mint(msg.sender, liquidity);
    }

    function removeLiquity(uint256 _lpAmount) public validAmount(_lpAmount) {
        require(
            lpToken.balanceOf(msg.sender) >= _lpAmount,
            "Not enough LP tokens"
        );

        uint256 _amountA = (_lpAmount * reserveA) / totalLiquidity;
        uint256 _amountB = (_lpAmount * reserveB) / totalLiquidity;

        lpToken.burn(msg.sender, _lpAmount);
        totalLiquidity -= _lpAmount;
        reserveA -= _amountA;
        reserveB -= _amountB;

        tokenA.transferFrom(address(this), msg.sender, _amountA);
        tokenB.transferFrom(address(this), msg.sender, _amountB);
    }

    function swap(
        address _tokenFrom,
        address _tokenTo,
        uint256 _amountIn
    ) public validAddress(_tokenFrom) validAddress(_tokenTo) validAmount(_amountIn) {
        // bool isTokenFromValid = _tokenFrom == address(tokenA) || _tokenFrom == address(tokenB);


    }
}
