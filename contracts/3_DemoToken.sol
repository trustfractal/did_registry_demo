// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./1_FractalRegistry.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title Demo ERC20 token contract
/// @notice Toy example of an ERC20 token that uses Fractal's DID Registry to
/// require KYC approval (and select citizenship and residency).
contract DemoToken is ERC20 {
    FractalRegistry registry;

    constructor(address registryAddress) ERC20("Demo Token", "DEMO") {
        registry = FractalRegistry(registryAddress);
    }

    /// @notice Buy tokens.
    /// The buyer is required to be in the used FractalRegistry, to have passed
    /// KYC `plus` level, to not be a Fiji resident, and not be an Iceland
    /// resident.
    function buy() external payable {
        require(msg.value > 0, "Can't buy zero tokens");

        bytes32 fractalId = registry.getFractalId(msg.sender);
        require(
            fractalId != 0 &&
                registry.isUserInList(fractalId, "plus") &&
                !registry.isUserInList(fractalId, "residency_fj") &&
                !registry.isUserInList(fractalId, "citizenship_is"),
            "Non KYC-compliant sender."
        );

        _mint(msg.sender, msg.value);
    }
}
