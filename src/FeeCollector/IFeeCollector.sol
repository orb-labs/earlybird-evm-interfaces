// src/FeeCollector/IFeeCollector.sol
// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.17;

/**
 * @author - Orb Labs
 * @title  - IFeeCollector.sol
 * @notice - Interface for oracle + relayer fee settings and collection
 */
interface IFeeCollector {
    /**
     * @dev - function returns the amount an oracle is willing to charge for passing a message
     * @param _app - Address of the application
     * @param _receiverInstanceId - bytes32 indicating the receiver's endpoint instance Id
     * @param _receiver - bytes array indicating the address of the receiver
     * @param _payload - bytes array containing message payload
     * @param _additionalParams - bytes array containing additional params application would like
     *                            sent to the library.
     * @return isTokenAccepted - bool indicating whether the token passed in additionalParams is acceptable or not.
     * @return estimatedFee - uint256 indicating the estimatedFee
     */
    function getEstimatedFeeForSendingMsg(
        address _app,
        bytes32 _receiverInstanceId,
        bytes calldata _receiver,
        bytes calldata _payload,
        bytes calldata _additionalParams
    ) external view returns (bool isTokenAccepted, uint256 estimatedFee);

    /**
     * @dev - function returns an array of tokens that are accepted as fees by the oracle
     * @param _app - Address of the application
     * @param _receiverInstanceId - bytes32 indicating the receiver's endpoint instance Id
     * @param _receiver - bytes array indicating the address of the receiver
     * @param _payload - bytes array containing message payload
     * @param _additionalParams - bytes array containing additional params application would like
     *                            sent to the library.
     * @return acceptedTokens - return array of address of tokens that it accepts.
     */
    function getAcceptedTokens(
        address _app,
        bytes32 _receiverInstanceId,
        bytes calldata _receiver,
        bytes calldata _payload,
        bytes calldata _additionalParams
    ) external view returns (address[] memory acceptedTokens);

    /**
     * @dev - function returns whether a token is accepted as for fees or not.
     * @param _tokens - address of tokens we are inquirying about
     * @param _app - Address of the application
     * @param _receiverInstanceId - bytes32 indicating the receiver's endpoint instance Id
     * @param _receiver - bytes array indicating the address of the receiver
     * @param _payload - bytes array containing message payload
     * @param _additionalParams - bytes array containing additional params application would like
     *                            sent to the library.
     * @return areAcceptedTokens - return array of address of tokens that it accepts.
     */
    function areTokensAccepted(
        address[] memory _tokens,
        address _app,
        bytes32 _receiverInstanceId,
        bytes calldata _receiver,
        bytes calldata _payload,
        bytes calldata _additionalParams
    ) external view returns (bool[] memory areAcceptedTokens);

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
     * @dev - function that lets the fee collector know that fee has been paid to send a particular message.
     *        Used by fee collector to specific functions related to fee payments be it paying a recommended
     *        relayer or sending funds to a fee to address.
     * @param _app - Address of the application
     * @param _receiverInstanceId - bytes32 indicating the receiver's endpoint instance Id
     * @param _receiver - bytes array indicating the address of the receiver
     * @param _payload - bytes array containing message payload
     * @param _additionalParams - bytes array containing additional params application would like
     *                            sent to the library.
     */
    function feePaidToSendMsg(
        address _app,
        bytes32 _receiverInstanceId,
        bytes calldata _receiver,
        bytes calldata _payload,
        bytes calldata _additionalParams
    ) external;

    /**
     * @dev - function that lets the fee collector know that fee has been paid for a delivered msg.
     *        Used by fee collector to specific functions related to fee payments be it paying a recommended
     *        relayer or sending funds to a fee to address.
     * @param _receiverApp - Address of the application that received the message
     * @param _senderInstanceId - bytes32 indicating the sender's endpoint instance Id
     * @param _sender - bytes array indicating the address of the sender
     * @param _payload - bytes array containing message payload
     * @param _additionalParams - bytes array containing additional params application would like
     *                            sent to the library.
     */
    function feePaidForDeliveredMsg(
        address _receiverApp,
        bytes32 _senderInstanceId,
        bytes calldata _sender,
        bytes calldata _payload,
        bytes calldata _additionalParams
    ) external;

    /**
     * @dev - function that allows the application to bookmark or save the amount they owe in fees for a delivered message on the receiver endpoint.
     *        Allows the app to return and pay the amount bookmarked even if the fee has increased.
     * @param _msgHash - bytes32 indicating the hash of the messsage whose fees are being bookmarked
     * @param _receiverApp - address indicating the app that received the message whose fee was bookmarked
     * @param _senderInstanceId - bytes32 indicating the instance id of the endpoint that sent the message
     * @param _sender - bytes array indicating the address of the sender
     *                    (bytes is used since the sender can be on an EVM or non-EVM chain)
     * @param _nonce - uint256 indicating the nonce of the message.
     * @param _payload - bytes array containing the message payload was delivered to the receiver
     * @param _additionalParams - bytes array containing additional params application passed to the library on the sender endpoint.
     * @return feeBookmarked - boolean indicating that the fee was bookmarked.
     */
    function bookmarkFeesForDeliveredMessage(
        bytes32 _msgHash,
        address _receiverApp,
        bytes32 _senderInstanceId,
        bytes calldata _sender,
        uint256 _nonce,
        bytes calldata _payload,
        bytes calldata _additionalParams
    ) external returns (bool feeBookmarked);

    /**
     * @dev - function that allows app to pay bookmarked fee
     * @param _receiverApp - Address of the application that received the message
     * @param _feeToken - address indicating the fee token
     * @param _msgHash - bytes32 indicating the msg of the message whose fee has been bookmarked.
     */
    function bookmarkedFeesPaid(address _receiverApp, address _feeToken, bytes32 _msgHash) external;
}
