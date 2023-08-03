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
