// src/EarlybirdEndpoint/IEarlybirdEndpointFunctionsForLibraries.sol
// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.17;

/**
 * @author - Orb Labs
 * @title  - IEarlybirdEndpointFunctionsForLibraries
 * @notice - Interface for Earlybird Endpoint functions that only the library can call.
 */
interface IEarlybirdEndpointFunctionsForLibraries {
    /**
     * @dev - Function that allows the library to deliver messages to applications that use it
     * @param _app - address of the app the message is being delivered to.
     * @param _senderInstanceId - bytes32 indicating the instance id of the earlybird endpoint from which the message is being sent.
     * @param _sender - bytes array indicating the address of the app sending the message.
     *                  (bytes is used since the receiver can be on an EVM or non-EVM chain)
     * @param _nonce - nonce of the message
     * @param _payload - bytes array indicating the message payload.
     * @param _additionalInfo - bytes array containing additional information the library would like to pass to _app
     */
    function deliverMessageToApp(
        address _app,
        bytes32 _senderInstanceId,
        bytes calldata _sender,
        uint256 _nonce,
        bytes calldata _payload,
        bytes calldata _additionalInfo
    ) external;

    /**
     * @dev - Function that allows the library to collect ERC20 Fee from App for the library
     * @param _app - address of the app we are collecting fees from
     * @param _token - address for the token
     * @param _feeTo - address of the person the tokens should be transferred to
     * @param _amount - uint256 indicating the amount of tokens that should be transferred.
     */
    function collectTokenFromAppForLibrary(address _app, address _token, address _feeTo, uint256 _amount) external;
}
