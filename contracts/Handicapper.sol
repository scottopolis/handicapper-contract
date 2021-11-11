// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Handicapper {

    uint private seed;

    // an event is like a log that lives on the block to give you more information about the txn
    event NewScore( address indexed golfer, string _course, uint _score, string _date, uint _slope, uint _rating, uint timestamp );

    // Some string type variables to identify the token.
    // The `public` modifier makes a variable readable from outside the contract.
    string public name = "My Score Token";
    string public symbol = "SBT";

    struct Score {
        address golfer;
        string course;
        uint score;
        string date;
        uint slope;
        uint rating;
        uint timestamp;
    }

    // create a variable that is an array with type of Score
    Score[] scores;

    // The fixed amount of tokens stored in an unsigned integer type variable.
    uint256 public totalSupply = 10000;

    // turn address into a number
    // access like lastSubmission[msg.sender]
    mapping(address => uint256) public lastSubmission;

    // An address type variable is used to store ethereum accounts.
    address public owner;

    mapping(address => uint256) balances;

    constructor() payable {
        console.log("Scotts handicap contract.");
        //seed = (block.timestamp + block.difficulty) % 100;
    }

    function submitScore( string memory _course, uint _score, string memory _date, uint _slope, uint _rating) public {

        /*
         * We need to make sure the current lastSubmission is at least 15-minutes bigger than the last lastSubmission we stored
         */
        require(
            lastSubmission[msg.sender] + 30 seconds < block.timestamp,
            "Wait 30 seconds"
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastSubmission[msg.sender] = block.timestamp;

        console.log('last ', lastSubmission[msg.sender]);

        this.transfer(msg.sender, 1);
        console.log("%s submitted", msg.sender);
        console.log("Gave sender a SBT token, balance is: ", this.balanceOf(msg.sender));

        scores.push(Score(msg.sender, _course, _score,  _date, _slope, _rating, block.timestamp));

        emit NewScore(msg.sender, _course, _score,  _date, _slope, _rating, block.timestamp);

        /*
         * Generate a new seed for the next user that sends a wave
         */
        //seed = (block.difficulty + block.timestamp + seed) % 100;

        /*
         * Give a 20% chance that the user wins the prize.
         */
        // if (seed > 40 && seed < 60 ) {
        //     console.log("%s won!", msg.sender);

        //     /*
        //      * The same code we had before to send the prize.
        //      */
        //     uint256 prizeAmount = 0.0001 ether;
        //     require(
        //         prizeAmount <= address(this).balance,
        //         "Trying to withdraw more money than the contract has."
        //     );
        //     (bool success, ) = (msg.sender).call{value: prizeAmount}("");
        //     require(success, "Failed to withdraw money from contract.");
        // }
    }

    function getAllScores() public view returns(Score[] memory) {
        return scores;
    }

    // function getMyScores(address account) public view returns(Score[] memory) {
    //     return scores[account];
    // }

    function getSupply() public view returns(uint) {
        return totalSupply;
    }

    
    function transfer( address to, uint amount) public {
        if( totalSupply >= amount ) {
            balances[to] += amount;
            totalSupply -= amount;
            console.log("Token awarded to sender: ", this.balanceOf(to));
            console.log(totalSupply);
        }
    }

    /**
     * Read only function to retrieve the token balance of a given account.
     *
     * The `view` modifier indicates that it doesn't modify the contract's
     * state, which allows us to call it without executing a transaction.
     */
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }
}