// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract ReceiverOne {
    event Received(address caller, uint amount, string message);

    fallback() external payable {
        emit Received(msg.sender, msg.value, "Fallback was called");
    }

    function fooOne(string memory _message, uint _x) public payable returns (uint) {
        emit Received(msg.sender, msg.value, _message);

        return _x + 1;
    }
}

contract CallerOne {
    event Response(bool success, bytes data);

    // Let's imagine that contract B does not have the source code for
    // contract A, but we do know the address of A and the function to call.


    function testCallFooOne(address payable _addr) public payable {
       
        // You can send ether and if you like you can specify a custom gas amount:
        //(bool success, bytes memory data) = _addr.call{value: msg.value, gas: 5000
       
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("fooOne(string,uint256)", "call fooOne", 123)
        );

        emit Response(success, data);
    }

    // Calling a function that does not exist triggers the fallback function.
    function testCallDoesNotExist(address _addr) public {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("doesNotExist()")
        );

        emit Response(success, data);
    }
}