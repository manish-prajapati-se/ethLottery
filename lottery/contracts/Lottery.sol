pragma solidity ^0.4.17;

contract Lottery {
    address public manager; //address of person who created the contract
    //'public' since we want our frontend to access manager

    address[] public players;// addresses of people who have entered

    function Lottery() public {
        manager = msg.sender;
        //msg.sender-> address of the account that invoked the function
    }

    function enter() public payable {
        //validating player with some minimum amount of ether for entering lottery
        require(msg.value > .01 ether);

        players.push(msg.sender); //add player to the list of players
    }

    //helper function to generate a random number
    function random() private view returns (uint) {
        //keccak256=sha3()
        //now -> current time
        return uint(keccak256(block.difficulty, now, players));
        //return a very large hex number
    }

    modifier restricted() {
        //only manager can pick the winner
        require(msg.sender == manager);
        _;
    }

    function pickWinner() public restricted {
        //randomly pick a winner and send them teh prize pool
        uint index = random() % players.length;
        players[index].transfer(this.balance);  
        //take the balance from the contract and transfer it to the winner's address
        
        players = new address[](0);
        //empty list of players and get ready for next round
    }


    //list of players who have entered lottery
    function getPlayers() public view returns (address[]) {
        return players;
    }
}
