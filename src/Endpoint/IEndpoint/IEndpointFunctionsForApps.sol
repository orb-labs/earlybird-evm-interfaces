// src/Endpoint/IEndpoint/IEndpointFunctionsForApps.sol
// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.17;

/**
 * @author - Orb Labs
 * @title  - IEndpointFunctionsForApps
 * @notice - Interface for Endpoint functions only the application can call.
 */
interface IEndpointFunctionsForApps {
    /**
     * @dev - Function to select a library and set app config for the library's
     *        send and receive module for a given application
     * @param _libraryName - string of the name of the library the application will use to send messages
     * @param _appConfigForSending - bytes array containing encoded app config for the send module
     * @param _appConfigForReceiving - bytes array containing encoded app config for the receive module
     * @return sendModule - address of the selected library's sendModule
     * @return receiveModule - address of the selected library's receiveModule
     */
    function setLibraryAndConfigs(
        string calldata _libraryName,
        bytes calldata _appConfigForSending,
        bytes calldata _appConfigForReceiving
    ) external returns (address sendModule, address receiveModule);

    /**
     * @dev - Function for updating an app config on a given library's send module
     * @param _appConfigForSending - bytes array containing encoded configs to be passed to
     *                             the send module on the applications behalf
     */
    function updateAppConfigForSending(bytes calldata _appConfigForSending) external;

    /**
     * @dev - Function that allows application to update its library's receive module configs
     * @param _appConfigForReceiving - bytes array containing encoded configs to be passed
     *                                to the receive module on the applications behalf
     */
    function updateAppConfigForReceiving(bytes calldata _appConfigForReceiving) external;

    /**
     * @dev - Function for applications to send a message to be broadcast by its selected library's send module
     * @param _receiverInstanceId - bytes32 indicating the instance id of the endpoint that is receiving the message
     * @param _receiver - bytes array indicating the address of the receiver
     *                    (bytes is used since the receiver can be on an EVM or non-EVM chain)
     * @param _payload - bytes array containing the message payload to be delivered to the receiver
     * @param _additionalParams - bytes array containing additional params application would like to passed to the library
     *                            May be used in the library to enable special functionality
     */
    function sendMessage(
        bytes32 _receiverInstanceId,
        bytes calldata _receiver,
        bytes calldata _payload,
        bytes calldata _additionalParams
    ) external payable;

    /**
     * @dev - Function for applications to send a message to be broadcast by its selected library's send module 
     *        wihout paying the message sending fee.  The app must them pay the fee for sending the message independently.
     * @param _receiverInstanceId - bytes32 indicating the instance id of the endpoint that is receiving the message
     * @param _receiver - bytes array indicating the address of the receiver
     *                    (bytes is used since the receiver can be on an EVM or non-EVM chain)
     * @param _payload - bytes array containing the message payload to be delivered to the receiver
     * @param _additionalParams - bytes array containing additional params application would like to passed to the library
     *                            May be used in the library to enable special functionality
     */
    function sendMessageWithoutPayingFees(
        bytes32 _receiverInstanceId,
        bytes calldata _receiver,
        bytes calldata _payload,
        bytes calldata _additionalParams
    ) external;

    /**
     * @dev - Function for applications to pay the fee for sending a message without sending the message.
     *        The user must send the message independently.
     * @param _receiverInstanceId - bytes32 indicating the instance id of the endpoint that is receiving the message
     * @param _receiver - bytes array indicating the address of the receiver
     *                    (bytes is used since the receiver can be on an EVM or non-EVM chain)
     * @param _payload - bytes array containing the message payload to be delivered to the receiver
     * @param _additionalParams - bytes array containing additional params application would like to passed to the library
     *                            May be used in the library to enable special functionality
     */
    function payFeesWithoutSendingMessage(
        bytes32 _receiverInstanceId,
        bytes calldata _receiver,
        uint256 _nonce,
        bytes calldata _payload,
        bytes calldata _additionalParams
    ) external payable;

    /**
     * @dev - Function for applications to pay the fee for a delivered message on the receiver endpoint instead of the sender endpoint.
     *        Coupled with the sendMessageWithoutPayingFees(), apps should be able to send messages and pay on the destination.
     * @param _senderInstanceId - bytes32 indicating the instance id of the endpoint that sent the message
     * @param _sender - bytes array indicating the address of the sender
     *                    (bytes is used since the sender can be on an EVM or non-EVM chain)
     * @param _payload - bytes array containing the message payload was delivered to the receiver
     * @param _additionalParams - bytes array containing additional params application passed to the library on the sender endpoint.
     */
    function payFeesForDeliveredMessage(
        bytes32 _senderInstanceId,
        bytes calldata _sender,
        uint256 _nonce,
        bytes calldata _payload,
        bytes calldata _additionalParams
    ) external payable;

    /**
     * @dev - Function for applications to bookmark or save the amount they owe in fees for a delivered message on the receiver endpoint.
     *        Allows the app to return and pay the amount bookmarked even if the fee has increased.
     * @param _senderInstanceId - bytes32 indicating the instance id of the endpoint that sent the message
     * @param _sender - bytes array indicating the address of the sender
     *                    (bytes is used since the sender can be on an EVM or non-EVM chain)
     * @param _nonce - uint256 indicating the nonce of the message.
     * @param _payload - bytes array containing the message payload was delivered to the receiver
     * @param _additionalParams - bytes array containing additional params application passed to the library on the sender endpoint.
     * @return msgHash - the hash of the delivered msg whose fee was bookmarked
     */
    function bookmarkFeesForDeliveredMessage(
        bytes32 _senderInstanceId,
        bytes calldata _sender,
        uint256 _nonce,
        bytes calldata _payload,
        bytes calldata _additionalParams
    ) external returns (bytes32 msgHash);

    /**
     * @dev - Function for applications to pay bookmarked fees.
     * @param _feeToken - uint256 indicating the token the fee should be played in.
     * @param _msgHash - bytes32 indicating the msgHash of the bookmarked message
     */
    function payBookmarkedFees(address _feeToken, bytes32 _msgHash) external payable;

    /**
     * @dev - Function allows anyone to retry delivering a failed message
     * @param _app - address of the app where the message is to be delivered
     * @param _senderInstanceId - bytes32 indicating the instance id of the earlybird endpoint from 
     *                            which the sender is sending the message.
     * @param _sender - bytes indicating the address of the sender app
     *                  (bytes is used since the sender can be on an EVM or non-EVM chain)
     * @param _nonce - uint256 indicating the nonce or id of the failed message
     * @param _payload - bytes array containing the message payload to be delivered to the app
     */
    function retryDeliveryForFailedMessage(
        address _app,
        bytes32 _senderInstanceId,
        bytes calldata _sender,
        uint256 _nonce,
        bytes calldata _payload,
        bytes calldata _additionalInfo
    ) external payable;
}
