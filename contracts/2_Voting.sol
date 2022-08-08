// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {FractalRegistry} from "./1_FractalRegistry.sol";

/// @title Simplified vote contract
/// @notice Example usage of Fractal's DID Registry to enable "One Person <=> One Vote".
contract Voting {
    FractalRegistry fractalRegistry;

    uint8 numOptions;
    mapping(uint8 => uint8) votes;
    mapping(bytes32 => bool) voters;

    constructor(uint8 _numOptions, address _fractalRegistryAddress) {
        numOptions = _numOptions;
        fractalRegistry = FractalRegistry(_fractalRegistryAddress);
    }

    /// @notice Cast a vote.
    /// @param option The option to vote for.
    function vote(uint8 option) external {
        require(option < numOptions, "Must vote for a valid option");

        bytes32 fractalId = fractalRegistry.getFractalId(msg.sender);
        require(!voters[fractalId], "Can't vote twice");

        voters[fractalId] = true;
        votes[option] += 1;
    }

    function currentTally() external view returns(uint8[] memory) {
      uint8[] memory votes_ = new uint8[](numOptions);
      for(uint8 i = 0; i < numOptions; i++) {
        votes_[i] = votes[i];
      }
      return votes_;
    }
}
