// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Assessment {
    address payable public owner;
    uint256 public balance;

    event Deposit(uint256 amount);
    event Withdraw(uint256 amount);
    event Redeem(string itemName);

    struct Nft {
        string name;
        uint256 price;
    }

    mapping(uint256 => Nft) public nftItems;

    constructor(uint initBalance) payable {
        owner = payable(msg.sender);
        balance = initBalance;
        storeNftItem(0, "Helmet", 50);
        storeNftItem(1, "Wheel", 100);
        storeNftItem(2, "Handle Bar", 200);
        storeNftItem(3, "Visor", 250);
    }

    function storeNftItem(uint256 itemId, string memory itemName, uint256 itemPrice) private {
        nftItems[itemId] = Nft(itemName, itemPrice);
    }

    function getBalance() public view returns(uint256){
        return balance;
    }

    function deposit(uint256 _amount) public payable {
        uint _previousBalance = balance;

        // make sure this is the owner
        require(msg.sender == owner, "You are not the owner of this account");

        // perform transaction
        balance += _amount;

        // assert transaction completed successfully
        assert(balance == _previousBalance + _amount);

        // emit the event
        emit Deposit(_amount);
    }

    // custom error
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function withdraw(uint256 _withdrawAmount) public {
        require(msg.sender == owner, "You are not the owner of this account");
        uint _previousBalance = balance;
        if (balance < _withdrawAmount) {
            revert InsufficientBalance({
                balance: balance,
                withdrawAmount: _withdrawAmount
            });
        }

        // withdraw the given amount
        balance -= _withdrawAmount;

        // assert the balance is correct
        assert(balance == (_previousBalance - _withdrawAmount));

        // emit the event
        emit Withdraw(_withdrawAmount);
    }

    function redeem(uint256 itemId) public {
        require(nftItems[itemId].price > 0, "Invalid item ID.");
        require(balance >= nftItems[itemId].price, "Insufficient balance for redemption.");

        // Burn tokens
        balance -= nftItems[itemId].price;

        // Emit event for redemption
        emit Redeem(nftItems[itemId].name);
    }
}
