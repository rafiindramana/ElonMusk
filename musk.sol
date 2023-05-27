// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ElonMusk is ERC20, Ownable {
    uint256 public buyTaxPercentage = 3;
    uint256 public sellTaxPercentage = 3;

    constructor() ERC20("ElonMusk", "MUSK") {
        _mint(msg.sender, 10000000000 * 10 ** decimals());
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        if (_msgSender() == owner()) {
            _transfer(_msgSender(), recipient, amount);
        } else {
            uint256 buyTaxAmount = (amount * buyTaxPercentage) / 100;
            uint256 sellTaxAmount = (amount * sellTaxPercentage) / 100;
            uint256 transferAmount = amount - buyTaxAmount - sellTaxAmount;
            
            _transfer(_msgSender(), recipient, transferAmount);
            if (buyTaxAmount > 0) {
                _transfer(_msgSender(), owner(), buyTaxAmount);
            }
            if (sellTaxAmount > 0) {
                _transfer(_msgSender(), owner(), sellTaxAmount);
            }
        }
        
        return true;
    }
    
    function setBuyTaxPercentage(uint256 percentage) external onlyOwner {
        require(percentage <= 100, "Tax percentage cannot exceed 100");
        buyTaxPercentage = percentage;
    }
    
    function setSellTaxPercentage(uint256 percentage) external onlyOwner {
        require(percentage <= 100, "Tax percentage cannot exceed 100");
        sellTaxPercentage = percentage;
    }
}
