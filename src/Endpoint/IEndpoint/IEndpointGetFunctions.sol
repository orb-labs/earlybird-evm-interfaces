// src/Endpoint/IEndpoint/IEndpointGetFunctions.sol
// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.17;

/**
 * @author - Orb Labs
 * @title  - IEndpointGetFunctions
 * @notice - Interface for Endpoint get functions.
 */
interface IEndpointGetFunctions {
    /**
     * @dev - Function returns the endpoint instance Id
     */
    function getInstanceId() external returns (bytes32);

    /**
     * @dev - Function returns an array of all the libraries that have been added to the protocol
     */
    function getAllLibraryNames() external view returns (string[] memory);

    /**
     * @dev - Function returns a library's info give a library name
     * @param _libraryName - string indicating the library's name
     * @return libraryId - uint256 indicating the id of the library
     * @return sendModule - address of the send module
     * @return receiveModule - address of the receive module
     * @return isDeprecated - boolean telling us whether the library is deprecated or not
     */
    function getLibraryInfo(string calldata _libraryName)
        external
        view
        returns (uint256 libraryId, address sendModule, address receiveModule, bool isDeprecated);

    /**
     * @dev - Function returns an application's selected library and info
     * @param _app - Address of the application
     * @return libraryName - string indicating the library's name
     * @return libraryId - uint256 indicating the id of the library
     * @return sendModule - address of the send module
     * @return receiveModule - address of the receive module
     * @return isDeprecated - boolean telling us whether the library is deprecated or not
     */
    function getLibrary(address _app)
        external
        view
        returns (string memory libraryName, uint256 libraryId, address sendModule, address receiveModule, bool isDeprecated);

    /**
     * @dev - Function returns the info for a library with a particular library id
     * @param _libraryId - uint256 indicating the id of a library
     * @return libraryName - string indicating the library's name
     * @return sendModule - address of the send module
     * @return receiveModule - address of the receive module
     * @return isDeprecated - boolean telling us whether the library is deprecated or not
     */
    function getLibraryById(uint256 _libraryId)
        external
        view
        returns (string memory libraryName, address sendModule, address receiveModule, bool isDeprecated);

    /**
     * @dev - Function returns the library Fee settings
     * @param _libraryName - string indicating the name of library
     * @param _moduleType - uint256 indicating the module type
     * @return protocolFeeSettings - bytes containing an app's send library configs
     */
    function getProtocolFeeSettings(string calldata _libraryName, uint256 _moduleType)
        external
        view
        returns (bytes memory protocolFeeSettings);

    /**
     * @dev - Function returns the library Fee settings
     * @param _app - string indicating the name of library
     * @param _moduleType - uint256 indicating the module type
     * @return isProtocolFeeOn - bool indicating whether protocol fees are on or not.
     * @return protocolFeeToken - address of the token accepted as protocol fees.
     * @return protocolFeeAmount - amount of the token accepted for protocol fees.
     */
    function getProtocolFee(address _app, uint256 _moduleType)
        external
        view
        returns (bool isProtocolFeeOn, address protocolFeeToken, uint256 protocolFeeAmount);

    /**
     * @dev - Function returns the app's send module configs
     * @param _app - Address of the application
     * @return appConfigForSending - bytes containing an app's send module configs
     */
    function getAppConfigForSending(address _app) external returns (bytes memory appConfigForSending);

    /**
     * @dev - Function returns the app's app config from the receive module
     * @param _app - Address of the application
     * @return appConfigForReceiving - bytes containing the app's app config from the receive module
     */
    function getAppConfigForReceiving(address _app) external returns (bytes memory appConfigForReceiving);

    /**
     * @dev - Function returns the app's dynamic settings contract for the current library
     * @param _app - Address of the application
     * @return dynamicSettingsContract - address indicating the dynamic settings contract for the app
     */
    function getAppDynamicSettingsContract(address _app) external returns (address dynamicSettingsContract);

    /**
     * @dev - Function returns the sending nonce for app when it is sending messages to the receiver on the receiverInstanceId
     *        through libraryName. App has a different nonce for each receiver on each endpoint instance to which it sends messages.
     * @param _libraryName - string indicating name of the library whose sending library nonce is being returned
     * @param _app - address of the application that has been sending the messages
     * @param _receiverInstanceId - bytes32 indicating the instance id of the receiver's endpoint
     * @param _receiver - bytes array indicating the receiver's address
     *                    (bytes is used since the receiver can be from an EVM or non-EVM chain)
     * @return sendingNonce - uint256 indicating the outbound nonce
     */
    function getSendingNonce(
        string calldata _libraryName,
        address _app,
        bytes32 _receiverInstanceId,
        bytes memory _receiver
    ) external view returns (uint256 sendingNonce);

    /**
     * @dev - Function returns the receiving nonce for app when it is receiving messages from sender on the senderInstanceId
     *        through libraryName. App has a different nonce for each sender on each endpoint instance from which it receives messages.
     * @param _libraryName - string indicating name of the library whole receive library nonce is being returned
     * @param _app - address of the application that has been receiving the messages
     * @param _senderInstanceId - bytes32 indicating the id of the sender's endpoint instance id
     * @param _sender - bytes array indicating the sender's address
     *                  (bytes is used since the sender can be from an EVM or non-EVM chain)
     * @return receivingNonce - uint256 indicating the inbound nonce
     */
    function getReceivingNonce(string calldata _libraryName, address _app, bytes32 _senderInstanceId, bytes memory _sender)
        external
        view
        returns (uint256 receivingNonce);

    /**
     * @dev - Function returns whether a token is accepted as a sending fee and the amount of the tokens
     *        the app would have to pay to send a message from one instance to another.
     * @param _app - Address of the app sending the message.
     * @param _receiverInstanceId - bytes32 indicating the receiver's endpoint instance Id
     * @param _receiver - bytes array indicating the address of the receiver
     *                    (bytes is used since the receiver can be on an EVM or non-EVM chain)
     * @param _payload - bytes array containing message payload
     * @param _additionalParams - bytes array containing additional params.
     * @return isTokenAccepted - bool indicating whether the token passed in the additional params is accepted
     * @return feeEstimate - uint256 indicating the sendingFeeEstimate
     */
    function getSendingFeeEstimate(
        address _app,
        bytes32 _receiverInstanceId,
        bytes calldata _receiver,
        bytes calldata _payload,
        bytes calldata _additionalParams
    ) external view returns (bool isTokenAccepted, uint256 feeEstimate);

    /**
     * @dev - Function returns all the tokens accepted as fees for sending messages.
     * @param _app - Address of the app sending the message.
     * @param _receiverInstanceId - bytes32 indicating the receiver endpoint instance Id
     * @param _receiver - bytes array indicating the address of the receiver
     *                    (bytes is used since the receiver can be from an EVM or non-EVM chain)
     * @param _payload - bytes array containing message payload
     * @return acceptedTokens - array containing the address of all the tokens accepted as fee by the
     *                          library sending the message. Native tokens are represented as the address(0).
     */
    function getAcceptedTokensForSendingFees(
        address _app,
        bytes32 _receiverInstanceId,
        bytes calldata _receiver,
        bytes calldata _payload
    ) external view returns (address[] memory acceptedTokens);

    /**
     * @dev - Function returns fee caller must pay before they are able to retry delivering the failed message
     * @param _libraryName - string indicating name of the library whole receive library nonce is being returned
     * @param _app - address of the app the message is being delivered to.
     * @param _senderInstanceId - bytes32 indicating the instance id of the sender's endpoint
     * @param _sender - bytes indicating the address of the sender
     *                  (bytes is used since the sender can be from an EVM or non-EVM chain)
     * @param _nonce - uint256 indicating the index of the failed message in the array of failed messages
     * @return failedMsgHash - bytes32 indicating the hash of the failed msg.
     * @return feeForFailedMessage - uint256 indicating the fee caller must pay to relayer before
     *                               they are able to retry delivering the failed message
     * @return relayerThatDeliveredMsg - address of relayer that delivered the failed msg.
     */
    function getFailedMessageByNonce(
        string calldata _libraryName,
        address _app,
        bytes32 _senderInstanceId,
        bytes calldata _sender,
        uint256 _nonce
    ) external view returns (bytes32 failedMsgHash, uint256 feeForFailedMessage, address relayerThatDeliveredMsg);

    /**
     * @dev - Function returns array of hashes of failed messages sent from a sender on senderInstanceId through libraryName
     * @param _libraryName - string indicating name of the library whole receive library nonce is being returned
     * @param _app - address of the app the message is being delivered to.
     * @param _senderInstanceId - bytes32 indicating the instance id of the sender's endpoint
     * @param _sender - bytes indicating the address of the sender app
     *                  (bytes is used since the sender can be from an EVM or non-EVM chain)
     * @return noncesOfFailedMsgs - array of uint256 indicating the nonces of failed msgs
     */
    function getFailedMessageNonces(
        string calldata _libraryName,
        address _app,
        bytes32 _senderInstanceId,
        bytes calldata _sender
    ) external view returns (uint256[] memory noncesOfFailedMsgs);

    /**
     * @dev - Function returns whether endpoint is in the process of sending a message or not.
     */
    function isSendingMessage() external view returns (bool);

    /**
     * @dev - Function returns whether endpoint is in the process of delivering a message or not.
     */
    function isDeliveringMessageToApp() external view returns (bool);

    /**
     * @dev - Function returns whether endpoint is in the process of retrying a message delivery or not.
     */
    function isRetryingMessageDelivery() external view returns (bool);
}
