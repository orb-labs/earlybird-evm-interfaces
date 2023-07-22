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
     * @param _receiverChainId - uint256 indicating the receiver chain Id
     * @param _receiver - bytes array indicating the address of the receiver
     * @param _payload - bytes array containing message payload
     * @param _additionalParams - bytes array containing additional params application would like
     *                            sent to the library.  In this library, it is abi.encode(address feeToken).
     *                            Its an empty string if you are paying in native tokens.
     * @return isTokenAccepted - bool indicating whether the token passed in additionalParams is acceptable or not.
     * @return estimatedFee - uint256 indicating the estimatedFee
     */
    function getEstimatedFee(
        address _app,
        uint256 _receiverChainId,
        bytes calldata _receiver,
        bytes calldata _payload,
        bytes calldata _additionalParams
    ) external view returns (bool isTokenAccepted, uint256 estimatedFee);

    /**
     * @dev - function returns an array of tokens that are accepted as fees by the oracle
     * @param _app - Address of the application
     * @param _receiverChainId - uint256 indicating the receiver chain Id
     * @param _receiver - bytes array indicating the address of the receiver
     * @param _payload - bytes array containing message payload
     * @return acceptedTokens - return array of address of tokens that it accepts.
     */
    function getAcceptedTokens(
        address _app,
        uint256 _receiverChainId,
        bytes calldata _receiver,
        bytes calldata _payload
    ) external view returns (address[] memory acceptedTokens);

    /**
     * @dev - function returns whether a token is accepted as for fees or not.
     * @param _tokens - address of tokens we are inquirying about
     * @param _app - Address of the application
     * @param _receiverChainId - uint256 indicating the receiver chain Id
     * @param _receiver - bytes array indicating the address of the receiver
     * @param _payload - bytes array containing message payload
     * @return areAcceptedTokens - return array of address of tokens that it accepts.
     */
    function areTokensAccepted(
        address[] memory _tokens,
        address _app,
        uint256 _receiverChainId,
        bytes calldata _receiver,
        bytes calldata _payload
    ) external view returns (bool[] memory areAcceptedTokens);
}
