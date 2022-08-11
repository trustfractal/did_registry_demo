// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {FractalRegistry} from "./1_FractalRegistry.sol";

/// @title Simplified, non-secret, voting contract
/// @notice Toy example of Fractal's DID Registry usage to enable "One Person <=> One Vote".
contract Voting {
    FractalRegistry registry;

    uint8 private numOptions;
    mapping(uint8 => uint8) private votes;
    mapping(bytes32 => bool) private hasVoted;

    constructor(uint8 options, address registryAddress) {
        numOptions = options;
        registry = FractalRegistry(registryAddress);
    }

    /// @notice Cast a vote.
    /// @param option The option to vote for.
    function vote(uint8 option) external {
        require(
            option < numOptions,
            "Invalid option: `option` must be lower than `options`."
        );

        bytes32 fractalId = registry.getFractalId(msg.sender);
        require(
            fractalId != 0,
            "Unregistered user: user must be present in FractalRegistry."
        );
        require(
            !hasVoted[fractalId],
            "Already voted: the same person can't vote twice."
        );

        hasVoted[fractalId] = true;
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
