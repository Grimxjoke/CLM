pragma solidity 0.8.23;
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenReceiver is Ownable {
    using SafeERC20 for IERC20;

    // Event to log the receipt of tokens
    event TokensReceived(address from, uint256 amount, address token);

    /**
     * @dev Function to handle the receipt of tokens.
     * This function can be called by external contracts when they transfer tokens to this contract.
     * @param from The address sending the tokens
     * @param amount The amount of tokens being sent
     * @param token The address of the token being transferred
     */
    function onTokensReceived(address from, uint256 amount, address token) external {
        // You can add any logic here, such as recording the transfer, updating balances, etc.
        emit TokensReceived(from, amount, token);
    }

    /**
     * @dev A function to transfer tokens from this contract to another address.
     * @param to The address to send tokens to
     * @param amount The amount of tokens to send
     * @param token The address of the token to transfer
     */
    function transferTokens(address to, uint256 amount, address token) external onlyOwner {
        IERC20(token).safeTransfer(to, amount);
    }

    /**
     * @dev A function to approve another address to spend tokens on behalf of this contract.
     * @param spender The address to approve
     * @param amount The amount of tokens to approve
     * @param token The address of the token
     */
    function approveTokens(address spender, uint256 amount, address token) external onlyOwner {
        IERC20(token).safeApprove(spender, amount);
    }
}