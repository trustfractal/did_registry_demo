// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {FractalRegistry} from "./1_FractalRegistry.sol";

/// @title Simplified, non-secret, voting contract
/// @notice Toy example of Fractal's DID Registry usage to enable "One Person <=> One Vote".
contract Voting {
    FractalRegistry fractalRegistry;

    uint8 public numOptions;
    mapping(uint8 => uint8) public votes;
    mapping(bytes32 => bool) public has_voted;

    constructor(uint8 _numOptions, address _fractalRegistryAddress) {
        numOptions = _numOptions;
        fractalRegistry = FractalRegistry(_fractalRegistryAddress);
    }

    /// @notice Cast a vote.
    /// @param option The option to vote for.
    function vote(uint8 option) external {
        require(
            option < numOptions,
            "Invalid option: `option` must be lower than `numOptions`"
        );

        bytes32 fractalId = fractalRegistry.getFractalId(msg.sender);
        require(
            !has_voted[fractalId],
            "Invalid call: same person can't vote twice."
        );
        has_voted[fractalId] = true;

        votes[option] += 1;
    }

    /// @notice Get the current count for each option.
    function currentTally() external view returns (uint8[] memory) {
        uint8[] memory votes_ = new uint8[](numOptions);
        for (uint8 i = 0; i < numOptions; i++) {
            votes_[i] = votes[i];
        }
        return votes_;
    }
}
