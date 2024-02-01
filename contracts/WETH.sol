pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20 {
    event Deposit(address indexed from, uint256 value);
    event Withdrawal(address indexed to, uint256 value);

    mapping(address => uint256) public balances;

    constructor() ERC20("Wrapped Ether", "WETH") {}

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount);
        balances[msg.sender] -= amount;
        _burn(msg.sender, amount);
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    function decimals() public view override returns (uint8) {
        return 18; 
    }
}