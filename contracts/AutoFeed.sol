// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract AutoFeed is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private ids;

    bool private stateAF;

    mapping(uint => uint) private history;
    event History(uint indexed id, uint indexed times);

    constructor() {
        stateAF = false;
        ids.increment();
    }

    function changeState() external onlyOwner {
        if (stateAF == true) {
            stateAF = false;
        } else {
            stateAF = true;
        }
    }

    function showState() external view returns(bool) {
        return stateAF;
    }

    function input() external onlyOwner {
        uint _id = ids.current();
        uint _times = block.timestamp;
        history[_id] = _times;
        emit History(_id, _times);
        ids.increment();
    }

    function showHistory(uint from, uint to) external view returns(uint[] memory, uint[] memory) {
        require(from > 0 && to > 0, "ERRSH1");
        require(from > to, "ERRSH2");
        uint num = from;
        uint length = from - to;
        uint[] memory _ids = new uint[](length);
        uint[] memory _times = new uint[](length);
        for (uint i = 0; i < (from - to); i++) {
            _ids[i] = num;
            _times[i] = history[num];
            num--;
        }
        return (_ids, _times);
    }
}