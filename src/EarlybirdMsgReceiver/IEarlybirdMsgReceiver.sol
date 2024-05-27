// src/EarlybirdMsgReceiver/IEarlybirdMsgReceiver.sol
// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.17;

/**
 * @author - Orb Labs
 * @title  - IEarlybirdMsgReceiver
 * @notice - Interface for receiving messages from the earlybird endpoint.
 */
interface IEarlybirdMsgReceiver {
    /**
     * @dev - Function that allows the app to receive messages from the earlybird endpoint.
     * @param _senderInstanceId - bytes32 indicating instance id of sender's earlybird endpoint.
     * @param _sender - bytes array indicating entity or application that sent the message.
     *                  (bytes is used since the sender can be on an EVM or non-EVM chain)
     * @param _payload - bytes array containing the message being delivered.
     * @param _additionalInfo - bytes array containing additional params library would like passed to the application.
     */
    function receiveMsg(
        bytes32 _senderInstanceId,
        bytes memory _sender,
        uint256 _nonce,
        bytes memory _payload,
        bytes memory _additionalInfo
    ) external;
}
