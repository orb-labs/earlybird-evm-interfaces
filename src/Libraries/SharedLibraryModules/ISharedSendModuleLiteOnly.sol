// src/Libraries/Rukh/RukhReceiveModule/IRukhSendModule.sol
// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.17;

/**
 * @author - Orb Labs
 * @title  - ISharedSendModuleLiteOnly
 * @notice - Interface for shared send module lite version only functions
 */
interface ISharedSendModuleLiteOnly {
    // event that broadcasts a message hash instead of the message
    event BroadcastMessageHash(bytes32 msgHash);

    /**
     * @dev - Getter function that returns whether lite broadcast is enabled on the send module.
     *        If false, the user cannot send lite broadcasted messages even if they are configured to do so.
     */
    function isLiteBroadcastEnabled() external view returns (bool);

    /**
     * @dev - Getter function that returns whether app is configured to self broadcast.
     * @param _app - address indicating the app we are requesting data for.
     */
    function isAppConfiguredToLiteBroadcast(address _app) external view returns (bool);

    /**
     * @dev - Getter function that lite broadcast config update code.
     *        Admins and users need to use this code when they are updating
     *        their library settings or app configs in order to use lite broadcast message.
     */
    function getLiteBroadcastConfigUpdateCode() external view returns (uint256);
}
