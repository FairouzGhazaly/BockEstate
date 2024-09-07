// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.9.0;

contract Migrations {
    address public owner;
    uint public last_completed_migration;

    // Constructor removed

    modifier restricted() {
        require(msg.sender == owner, "Restricted to owner");
        _;
    }

    function setCompleted(uint _completed) public restricted {
        last_completed_migration = _completed;
    }

    function upgrade(address _newAddress) public restricted {
        Migrations upgraded = Migrations(_newAddress);
        upgraded.setCompleted(last_completed_migration);
    }
}
