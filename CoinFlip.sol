pragma solidity >=0.7.0 <0.9.0;


contract CoinFlip {

    struct Account {
        bool created;
        int balance;
    }

    mapping(address => Account) accounts; 

    function createAccountIfNeeded(address user) private {
        if(!accounts[user].created) {
            accounts[user].created = true;
            accounts[user].balance = 100;
        }
    }

    mapping(address => bool) betStatus; // if a user has put a bet till now.

    struct Bet {
        address user;
        int guess;
        int amount;
    }

    Bet[] currentBets;

    function placeBet(int _amount, int _guess) public {
        address _user = msg.sender;
        createAccountIfNeeded(_user);
        require(
            accounts[_user].balance >= _amount,
            "Insufficient balance."
        );
        require(
            !betStatus[_user],
            "Bet Already placed."
        );
        currentBets.push(Bet(_user, _guess, _amount));
        accounts[_user].balance -= _amount;
        betStatus[_user] = true;
    }

    function rewardBets() public {
        int finalOutcome = 0;
        for(uint i = 0; i < currentBets.length; i++) {
            if(currentBets[i].guess == finalOutcome) {
                // winner
                accounts[currentBets[i].user].balance += 2*currentBets[i].amount;
            }
            else {
                // looser
            }
            betStatus[currentBets[i].user] = false;
        }
        delete currentBets;
    }

}
