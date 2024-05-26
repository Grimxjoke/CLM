// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Interface for Velodrome router
interface IVelodromeRouter {
    function addLiquidity(
        address tokenA,
        address tokenB,
        bool stable,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
}

contract VelodromeLiquidityProvider{
    IVelodromeRouter public velodromeRouter;
    IERC20 public tokenA;
    IERC20 public tokenB;
    bool public stable;

    constructor(
        address _velodromeRouter,
        address _tokenA,
        address _tokenB,
        bool _stable
    ) {
        velodromeRouter = IVelodromeRouter(_velodromeRouter);
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        stable = _stable;
    }

    function deposit(
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external {
        // Transfer tokens from the owner to this contract
        tokenA.transferFrom(msg.sender, address(this), amountADesired);
        tokenB.transferFrom(msg.sender, address(this), amountBDesired);

        // Approve the Velodrome router to spend the tokens
        tokenA.approve(address(velodromeRouter), amountADesired);
        tokenB.approve(address(velodromeRouter), amountBDesired);

        // Add liquidity
        velodromeRouter.addLiquidity(
            address(tokenA),
            address(tokenB),
            stable,
            amountADesired,
            amountBDesired,
            amountAMin,
            amountBMin,
            to,
            deadline
        );
    }
}