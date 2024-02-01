// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20DummyContract is ERC20 {
    uint256 public constant INITIAL_SUPPLY = 4000000 * (10**uint256(18));

    constructor() ERC20("TKN", "TKN") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function decimals() public view virtual override returns (uint8) {
        return 6;
    }

}