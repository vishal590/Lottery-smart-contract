//SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.5.0 < 0.9.0;

contract Lottery{
    address public manager;
    address payable[] public participants;  // this is dynamic array

    constructor(){
        manager = msg.sender;   // global variable
    }

    receive() external payable{       
        require(msg.value == 1 ether);
        participants.push(payable(msg.sender));

        // receive function use only one time in whole contract with external keyword
        // in 0.8 msg.sender is not automatically payable, so make it payable
    } 

    // receive is special function and it called one, 
    // receive is always exteranl and payable

    function getMoney() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }

    function selectWinner() public{
        require(msg.sender == manager);
        require(participants.length >= 3);
        uint r = random();
        address payable winner;
        uint index = r % participants.length;   // always this index remain less then r % participants.length;
        winner = participants[index];
        winner.transfer(getMoney());
        participants = new address payable[](0);
    }

}