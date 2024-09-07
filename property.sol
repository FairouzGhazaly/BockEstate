// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.9.0;

contract Property {
    address public owner;
    uint public deposit;
    uint public rent;
    address public tenant;
    string public house;
    uint public fromTimestamp;
    uint public toTimestamp;
    enum State {Available, Created, Approved, Started, Terminated}
    State public state;

    modifier onlyTenant() {
        require(msg.sender != tenant, 'Not a Tenant!');
        _;
    }

    modifier onlyOwner() {
        require(msg.sender != owner, 'Not an owner!');
        _;
    }

    modifier inState(State _state) {
        require(state == _state, 'State is not correct!');
        _;
    }



    function isAvailable() view public returns(bool) {
        return state == State.Available;
    }

    function createTenantRightAgreement(address _tenant, uint _fromTimestamp, uint _toTimestamp) inState(State.Available) public {
        tenant = _tenant;
        fromTimestamp = _fromTimestamp;
        toTimestamp = _toTimestamp;
        state = State.Created;
    }

    function setStatusApproved() inState(State.Approved) public onlyOwner {
        require(owner != address(0x0), 'Property not available for rentals!');
        state = State.Approved;
    }

    function confirmAgreement() inState(State.Approved) public onlyTenant {
        state = State.Started;
    }

    function clearTenant() public {
        tenant = address(0x0);
    }
}
