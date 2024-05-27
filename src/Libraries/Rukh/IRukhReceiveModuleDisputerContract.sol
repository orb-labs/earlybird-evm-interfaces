// src/Libraries/Rukh/IRukhReceiveModuleDisputerContract.sol
// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.17;

/**
 * @author - Orb Labs
 * @title  - IRukhReceiverModuleDisputerContract.sol
 * @notice - Interface for Rukh library's receive module's disputer contracts.
 *
 */
interface IRukhReceiveModuleDisputerContract {
    /**
     * @dev - function returns the amount an oracle is willing to charge for passing a message
     * @param _app - address indicating the app whose dispute got resolved
     * @param _disputedMsgProofHash - bytes32 indicating the hash of the disputed msg proof.
     * @param _disputeVerdict - uint256 indicating the dispute verdict.
     */
    function disputeResolved(address _app, bytes32 _disputedMsgProofHash, uint256 _disputeVerdict) external;
}
