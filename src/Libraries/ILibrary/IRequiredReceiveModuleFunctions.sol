// src/ILibrary/IRequiredReceiveModuleFunctions.sol
// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.17;

import "./IRequiredModuleFunctions.sol";

/**
 * @author - Orb Labs
 * @title  - IRequiredReceiveModuleFunctions
 * @notice - Interface for required receive module functions.
 *           These functions are mandatory because they are called by the Endpoint.
 */
interface IRequiredReceiveModuleFunctions is IRequiredModuleFunctions {
    /**
     * @dev - Struct that represents a message that Rukh receive module failed to deliver.
     * failedMsgHash - bytes32 representing failed msg hash
     * fee - uint256 indicating fee caller must pay before they can deliver the new failed message.
     * relayerThatDeliveredMsg - address of relayer that tried delivering the message.
     *                           It also happens to be the address the fee with be paid to.
     * nonceIndexInFailedMsgsArray - uint256 indicating the position of this failed msg's nonce in the failMsgs array.
     */
    struct FailedMsg {
        bytes32 failedMsgHash;
        uint256 fee;
        address relayerThatDeliveredMsg;
        uint256 nonceIndexInFailedMsgsArray;
    }

    /**
     * @dev - Function that allows the endpoint to get an applications receiveing nonce from the receive module.
     *        Each app has a different nonce for each sender on each earlybird instance from which it receives messages.
     * @param _app - address of the application that has been receiving the messages
     * @param _senderInstanceId - bytes32 indicating the id of the sender's earlybird instance
     * @param _sender - bytes array indicating the sender's address
     */
    function getReceivingNonce(address _app, bytes32 _senderInstanceId, bytes memory _sender)
        external
        view
        returns (uint256);

    /**
     * @dev - Function returns whether a token is accepted for fees and the amount of the tokens
     *        the app would have to pay in fees for an already delivered message.
     * @param _receiverApp - Address of the app receiving the message.
     * @param _senderInstanceId - bytes32 indicating the sender's endpoint instance Id
     * @param _sender - bytes array indicating the address of the sender
     *                    (bytes is used since the sender can be on an EVM or non-EVM chain)
     * @param _payload - bytes array containing message payload
     * @param _additionalParams - bytes array containing additional params that was delivered with the message on the source.
     * @return isTokenAccepted - bool indicating whether the token passed in the additional params is accepted
     * @return feeEstimate - uint256 indicating the sendingFeeEstimate
     */
    function getEstimatedFeeForDeliveredMessage(
        address _receiverApp,
        bytes32 _senderInstanceId,
        bytes calldata _sender,
        bytes calldata _payload,
        bytes calldata _additionalParams
    ) external view returns (bool isTokenAccepted, uint256 feeEstimate);

    /**
     * @dev - Function returns whether a token is accepted for a bookmarked fee and the amount of the tokens
     *        needed to pay back the bookmarked fee
     * @param _receiverApp - address indicating the receiver app
     * @param _msgHash - bytes32 indicating the msg hash
     * @param _feeToken - address indicating the fee token
     * @return isValidBookmark - bool indicating whether the bookmark is valid
     * @return isTokenAccepted - bool indicating whether the token passed in the additional params is accepted
     * @return fee - uint256 indicating the bookmarked fee
     */
    function getBookmarkedFee(address _receiverApp, address _feeToken, bytes32 _msgHash)
        external
        view
        returns (bool isValidBookmark, bool isTokenAccepted, uint256 fee);

    /**
     * @dev - Function returns array of hashes of failed messages sent from sender on a senderInstanceId
     * @param _app - address of the app the message is being delivered to.
     * @param _senderInstanceId - bytes32 indicating the id of the sender's earlybird instance
     * @param _sender - bytes indicating the address of the sender
     *                  (bytes is used since the sender can be on an EVM or non-EVM chain)
     * @return noncesOfFailedMsgs - array of bytes32 containing the hashes of failed msgs payloads
     */
    function getFailedMessageNonces(address _app, bytes32 _senderInstanceId, bytes memory _sender)
        external
        view
        returns (uint256[] memory noncesOfFailedMsgs);

    /**
     * @dev - Function returns fee caller must pay to receive module before they are able to retry
     *        delivering the failed message
     * @param _app - address of the app the message is being delivered to.
     * @param _senderInstanceId - bytes32 indicating the instance id of the sender's earlybird instance
     * @param _sender - bytes indicating the address of the sender
     *                  (bytes is used since the sender can be on an EVM or non-EVM chain)
     * @param _nonce - uint256 indicating the index of the failed message in the array of failed messages
     * @return failedMsgHash - bytes32 indicating the hash of the failed msg.
     * @return feeForFailedMessage - uint256 indicating the fee caller must pay to relayer before
     *                               they are able to retry delivering the failed message
     * @return relayerThatDeliveredMsg - address of relayer that delivered the failed msg.
     */
    function getFailedMessageByNonce(address _app, bytes32 _senderInstanceId, bytes memory _sender, uint256 _nonce)
        external
        view
        returns (bytes32 failedMsgHash, uint256 feeForFailedMessage, address relayerThatDeliveredMsg);

    /**
     * @dev - Application-only function that allows the application to pay the fee for a delivered message on the receiver endpoint instead of the sender endpoint.
     *        Coupled with the sendMessageWithoutPayingFees(), apps should be able to send messages and pay on the destination.
     * @param _receiverApp - address indicating the app that received the message
     * @param _senderInstanceId - bytes32 indicating the instance id of the endpoint that sent the message
     * @param _sender - bytes array indicating the address of the sender
     *                    (bytes is used since the sender can be on an EVM or non-EVM chain)
     * @param _nonce - uint256 indicating the nonce of the message
     * @param _payload - bytes array containing the message payload was delivered to the receiver
     * @param _additionalParams - bytes array containing additional params application passed to the library on the sender endpoint.
     */
    function payFeesForDeliveredMessage(
        address _receiverApp,
        bytes32 _senderInstanceId,
        bytes calldata _sender,
        uint256 _nonce,
        bytes calldata _payload,
        bytes calldata _additionalParams
    ) external payable;

    /**
     * @dev - Application-only function that allows the application to bookmark or save the amount they owe in fees for a delivered message on the receiver endpoint.
     *        Allows the app to return and pay the amount bookmarked even if the fee has increased.
     * @param _receiverApp - address indicating the app that received the message whose fee was bookmarked
     * @param _senderInstanceId - bytes32 indicating the instance id of the endpoint that sent the message
     * @param _sender - bytes array indicating the address of the sender
     *                    (bytes is used since the sender can be on an EVM or non-EVM chain)
     * @param _nonce - uint256 indicating the nonce of the message.
     * @param _payload - bytes array containing the message payload was delivered to the receiver
     * @param _additionalParams - bytes array containing additional params application passed to the library on the sender endpoint.
     * @return msgHash - the hash of the delivered msg whose fee was bookmarked
     */
    function bookmarkFeesForDeliveredMessage(
        address _receiverApp,
        bytes32 _senderInstanceId,
        bytes calldata _sender,
        uint256 _nonce,
        bytes calldata _payload,
        bytes calldata _additionalParams
    ) external returns (bytes32 msgHash);

    /**
     * @dev - Application-only function that allows the application to pay bookmarked fees.
     * @param _receiverApp - address indicating the app that received the message whose fee was bookmarked
     * @param _feeToken - uint256 indicating the token the fee should be played in.
     * @param _msgHash - bytes32 indicating the msgHash of the bookmarked message
     */
    function payBookmarkedFees(address _receiverApp, address _feeToken, bytes32 _msgHash) external payable;

    /**
     * @dev - Function allows anyone to retry delivering a failed message
     * @param _app - address of the app the message is being delivered to.
     * @param _senderInstanceId - bytes32 indicating the sender's earlybird instance id
     * @param _sender - bytes indicating the address of the sender
     *                  (bytes is used since the sender can be an EVM or non-EVM chain)
     * @param _nonce - uint256 indicating the nonce or id of the failed message.
     * @param _payload - bytes array containing the message payload to be delivered to the app
     * @param _additionalInfo - bytes array containing additional information the library would
     *                          have delivered to the app.
     */
    function retryDeliveryForFailedMessage(
        address _app,
        bytes32 _senderInstanceId,
        bytes memory _sender,
        uint256 _nonce,
        bytes memory _payload,
        bytes memory _additionalInfo
    ) external payable;
}
