// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IWETH.sol";

contract Vault {
    address public immutable wethAddress;

    mapping(address => mapping(address => uint256)) public tokensBalances;

    constructor(address _wethAddress) {
        wethAddress = _wethAddress;
    }

    function depositETH() public payable {
        tokensBalances[msg.sender][address(0)] += msg.value;
    }

    function withdrawETH(uint256 amount) public {
        require(tokensBalances[msg.sender][address(0)] >= amount, "Insufficient funds");
        tokensBalances[msg.sender][address(0)] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function depositERC20(address token, uint256 amount) public {
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        tokensBalances[msg.sender][token] += amount;
    }

    function withdrawERC20(address token, uint256 amount) public {
        require(tokensBalances[msg.sender][token] >= amount, "Insufficient funds");
        tokensBalances[msg.sender][token] -= amount;
        IERC20(token).transfer(msg.sender, amount);
    }

    function wrapETHtoWETH() public {
        require(tokensBalances[msg.sender][address(0)] > 0, "Insufficient ETH balance");
        uint256 amount = tokensBalances[msg.sender][address(0)];
        tokensBalances[msg.sender][address(0)] = 0;

        IWETH(wethAddress).deposit{value: amount}();
        tokensBalances[msg.sender][wethAddress] += amount;
    }

    function unwrapWETHtoETH() public {
        require(tokensBalances[msg.sender][wethAddress] > 0, "Insufficient WETH balance");
        uint256 amount = tokensBalances[msg.sender][wethAddress];
        tokensBalances[msg.sender][wethAddress] = 0;
        IWETH(wethAddress).withdraw(amount);
        payable(msg.sender).transfer(amount);
    }

    receive() external payable{}

}