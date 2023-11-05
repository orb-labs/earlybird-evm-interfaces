// src/ILibrary/IRequiredSendModuleFunctions.sol
// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.17;

import "./IRequiredModuleFunctions.sol";

/**
 * @author - Orb Labs
 * @title  - IRequiredSendModuleFunctions
 * @notice - Interface for required send module functions.
 *           These functions are required because they are called by the endpoint.
 */
interface IRequiredSendModuleFunctions is IRequiredModuleFunctions {
    /**
     * @dev - Function that allows endpoint to get an app's sending nonce if its not self-broadcasting.
     *        Each app has a different nonce for each receiver on each earlybird instance to which it sends messages.
     * @param _app - address of the application that has been sending the messages
     * @param _receiverInstanceId - bytes32 indicating the instance id of the receiver's earlybird endpoint
     * @param _receiver - bytes array indicating the receiver's address
     */
    function getSendingNonce(address _app, bytes32 _receiverInstanceId, bytes memory _receiver)
        external
        view
        returns (uint256);

    /**
     * @dev - Function returns the estimate for sending a message.
     * @param _app - address of the application
     * @param _receiverInstanceId - bytes32 indicating the receiver's earlybird instance Id
     * @param _receiver - bytes array indicating the address of the receiver
     *                    (bytes is used since the receiver can be on an EVM or non-EVM chain)
     * @param _payload - bytes array containing message payload
     * @param _additionalParams - bytes array containing additional params application would like
     *                            sent to the module. For this function, its the encoded address of the
     *                            token being used to pay the fee.
     * @return isTokenAccepted - bool indicating whether the token address passed in additionalParams is accepted or not.
     * @return estimatedFee - uint256 indicating the amount of the token that needed for the fee.
     */
    function getEstimatedFeeForSendingMsg(
        address _app,
        bytes32 _receiverInstanceId,
        bytes memory _receiver,
        bytes memory _payload,
        bytes memory _additionalParams
    ) external view returns (bool isTokenAccepted, uint256 estimatedFee);

    /**
     * @dev - Function returns an array of all the tokens accepted by the sending module as payment for fees
     * @param _app - address of the application sending the message
     * @param _receiverInstanceId - bytes32 indicating the instance id of the receiver's earlybird endpoint
     * @param _receiver - bytes array indicating the address of the receiver
     * @param _payload - bytes array containing the message payload to be delivered to the receiver
     * @return acceptedTokens - array of addresses of the tokens that are accepted by the protocol
     *                          as fees for sending messages.
     */
    function getAcceptedTokensForSendingFees(
        address _app,
        bytes32 _receiverInstanceId,
        bytes memory _receiver,
        bytes memory _payload
    ) external view returns (address[] memory acceptedTokens);

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
     * @return isTokenAccepted - bool indicating whether the token passed in the additional params is accepted
     * @return fee - uint256 indicating the bookmarked fee
     */
    function getBookmarkedFee(address _receiverApp, address _feeToken, bytes32 _msgHash)
        external
        view
        returns (bool isTokenAccepted, uint256 fee);

    /**
     * @dev - Application-only function that allows the application to send message to its designated
     *        outbound msg module to be broadcasted if it is not self-broadcasting
     * @param _app - address of the application sending the message
     * @param _receiverInstanceId - bytes32 indicating the instance id of the receiver's earlybird endpoint
     * @param _receiver - bytes array indicating the address of the receiver
     *                    (bytes is used since the receiver can be on an EVM or non-EVM chain)
     * @param _payload - bytes array containing the message payload to be delivered to the receiver
     * @param _additionalParams - bytes array containing additional params application would like passed to the module
     */
    function sendMessage(
        address _app,
        bytes32 _receiverInstanceId,
        bytes memory _receiver,
        bytes memory _payload,
        bytes memory _additionalParams
    ) external payable;

    /**
     * @dev - Application-only function that allows the application to send message to its designated
     *        outbound msg module to be broadcasted if it is not self-broadcasting without paying the fee.
     *        The app must pay the fee for sending the message independently.
     * @param _app - address of the application sending the message
     * @param _receiverInstanceId - bytes32 indicating the instance id of the receiver's earlybird endpoint
     * @param _receiver - bytes array indicating the address of the receiver
     *                    (bytes is used since the receiver can be on an EVM or non-EVM chain)
     * @param _payload - bytes array containing the message payload to be delivered to the receiver
     * @param _additionalParams - bytes array containing additional params application would like passed to the module
     */
    function sendMessageWithoutPayingFees(
        address _app,
        bytes32 _receiverInstanceId,
        bytes memory _receiver,
        bytes memory _payload,
        bytes memory _additionalParams
    ) external;

    /**
     * @dev - Application-only function that allows the application to pay fees to have a message delivered without sending the message itself.
     *        The app must send the message independently by calling sendMessageWithoutPayingFees() or self broadcasting.
     * @param _app - address of the application sending the message
     * @param _receiverInstanceId - bytes32 indicating the instance id of the receiver's earlybird endpoint
     * @param _receiver - bytes array indicating the address of the receiver
     *                    (bytes is used since the receiver can be on an EVM or non-EVM chain)
     * @param _nonce - uint256 indicating the message nonce
     * @param _payload - bytes array containing the message payload to be delivered to the receiver
     * @param _additionalParams - bytes array containing additional params application would like passed to the module
     */
    function payFeesWithoutSendingMessage(
        address _app,
        bytes32 _receiverInstanceId,
        bytes calldata _receiver,
        uint256 _nonce,
        bytes calldata _payload,
        bytes calldata _additionalParams
    ) external payable;

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
}
