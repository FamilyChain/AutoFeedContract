// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract AutoFeed is Ownable, Pausable {
    using Counters for Counters.Counter;
    Counters.Counter private ids;

    mapping(uint => uint) private history;
    event History(uint indexed id, uint indexed times);

    constructor() {
        ids.increment();
    }

    function pause() external onlyOwner whenNotPaused {
        _pause();
    }

    function unpause() external onlyOwner whenPaused {
        _unpause();
    }

    function input() external onlyOwner whenNotPaused {
        uint _id = ids.current();
        uint _times = block.timestamp;
        history[_id] = _times;
        emit History(_id, _times);
        ids.increment();
    }

    function currentIds() external view returns(uint) {
        return ids.current();
    }

    function showHistory(uint from, uint to) external view returns(uint[] memory, uint[] memory) {
        require(from > 0 && to > 0, "ERRSH");
        uint num = from > to ? from : to;
        uint length = from > to ? from - to : to - from;
        uint[] memory _ids = new uint[](length);
        uint[] memory _times = new uint[](length);
        for (uint i = 0; i < length; i++) {
            _ids[i] = num;
            _times[i] = history[num];
            num--;
        }
        return (_ids, _times);
    }
}