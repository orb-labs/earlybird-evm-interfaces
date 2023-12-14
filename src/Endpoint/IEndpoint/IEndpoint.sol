// src/Endpoint/IEndpoint/IEndpoint.sol
// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.17;

import "./IEndpointFunctionsForAdmins.sol";
import "./IEndpointFunctionsForApps.sol";
import "./IEndpointFunctionsForLibraries.sol";
import "./IEndpointGetFunctions.sol";
import "../../Libraries/ILibrary/IRequiredReceiveModuleFunctions.sol";
import "../../Libraries/ILibrary/IRequiredSendModuleFunctions.sol";

/**
 * @author - Orb Labs
 * @title  - IEndpoint
 * @notice - Complete Interface for Endpoint.
 */
interface IEndpoint is
    IEndpointFunctionsForAdmins,
    IEndpointFunctionsForApps,
    IEndpointFunctionsForLibraries,
    IEndpointGetFunctions
{
    /**
     * @dev - Enum representing library module types.
     * SEND - represents a libraries send module
     * RECEIVE - represents a libraries receive module
     */
    enum ModuleType {
        SEND,
        RECEIVE
    }

    /**
     * @dev - Struct representing an endpoint library
     * libraryId - uint256 indicating the id of the library
     * iSendModule - interface of the library's send module
     * iReceiveModule - interfaces of the library's receive module
     * isDeprecated - bool indicating whether the library is deprecated or not.
     * isInitialized - bool indicating whether the library is initialized or not.
     */
    struct LibraryObject {
        uint256 libraryId;
        IRequiredSendModuleFunctions iSendModule;
        IRequiredReceiveModuleFunctions iReceiveModule;
        bool isDeprecated;
        bool isInitialized;
    }

    /**
     * @dev - Event emitted when a new library is added to the protocol.
     * @param libraryName - string indicating the library name.
     * @param sendModule - address of the library's send module
     * @param receiveModule - address of the library's receive module.
     */
    event NewLibraryAdded(string libraryName, address indexed sendModule, address indexed receiveModule);

    /**
     * @dev - Event emitted when a library is deprecated.
     * @param libraryName - string indicating the library name.
     * @param sendModule - address of the library's send module
     * @param receiveModule - address of the library's receive module.
     * @param sendModulePausedSuccessfully - bool indicating whether the library send module paused successfully
     * @param receiveModulePausedSuccessfully - bool indicating whether the library receive module paused successfully
     *
     */
    event LibraryPaused(
        string libraryName,
        address indexed sendModule,
        bool sendModulePausedSuccessfully,
        address indexed receiveModule,
        bool receiveModulePausedSuccessfully
    );

    /**
     * @dev - Event emitted when a library is undeprecated
     * @param libraryName - string indicating the library name.
     * @param sendModule - address of the library's send module
     * @param receiveModule - address of the library's receive module.
     * @param sendModuleUnpausedSuccessfully - bool indicating whether library send module was unpaused successfully
     * @param receiveModuleUnpausedSuccessfully - bool indicating whether library receive module was unpaused successfully
     */
    event LibraryUnpaused(
        string libraryName,
        address indexed sendModule,
        bool sendModuleUnpausedSuccessfully,
        address indexed receiveModule,
        bool receiveModuleUnpausedSuccessfully
    );

    /**
     * @dev - Event emitted when a library is deprecated.
     * @param libraryName - string indicating the library name.
     * @param sendModule - address of the library's send module
     * @param receiveModule - address of the library's receive module.
     */
    event LibraryDeprecated(string libraryName, address indexed sendModule, address indexed receiveModule);

    /**
     * @dev - Event emitted when a library is undeprecated
     * @param libraryName - string indicating the library name.
     * @param sendModule - address of the library's send module
     * @param receiveModule - address of the library's receive module.
     */
    event LibraryUndeprecated(string libraryName, address indexed sendModule, address indexed receiveModule);

    /**
     * @dev - Event emitted when a library module's protocol fees settings are updated
     * @param libraryName - string indicating the library name.
     * @param moduleType - uint256 indicating whether it is the send or receive module
     * @param protocolFeeSettings - bytes indicating encoded protocol fee settings
     */
    event ProtocolFeeSettingsUpdated(string libraryName, uint256 indexed moduleType, bytes protocolFeeSettings);

    /**
     * @dev - Event emitted when a library is selected and app config created for an app
     * @param app - address of the app selecting and passing its configs to the library
     * @param sendModule - address of the library's send module
     * @param receiveModule - address of the library's receive module
     * @param libraryName - string indicating the name of the selected library
     * @param sendModuleConfigs - bytes indicating encoded send module configs
     * @param receiveModuleConfigs - bytes indicating encoded receive module configs
     */
    event AppLibraryAndConfigsSet(
        address indexed app,
        address indexed sendModule,
        address indexed receiveModule,
        string libraryName,
        bytes sendModuleConfigs,
        bytes receiveModuleConfigs
    );

    /**
     * @dev - Event emitted when an app updates its app config for sending messages over a given library
     * @param app - address of the app
     * @param libraryName - string indicating the library name
     * @param sendModule - address of the library's send module
     * @param appConfigForSending - bytes of encoded app configs for the send module
     */
    event AppSendModuleConfigsUpdated(
        address indexed app, string libraryName, address indexed sendModule, bytes appConfigForSending
    );

    /**
     * @dev - Event emitted when an app updates its app config for receiving messages over a given library
     * @param app - address of the app
     * @param libraryName - string indicating the library name
     * @param receiveModule - address of the library's receive module
     * @param appConfigForReceiving - bytes of encoded app configs for the receive module
     */
    event AppReceiveModuleConfigsUpdated(
        address indexed app, string libraryName, address indexed receiveModule, bytes appConfigForReceiving
    );

    /**
     * @dev - Event emitted when endpoint delivers message to an app
     * @param app - address of app where message was delivered
     * @param senderInstanceId - bytes32 indicating the sender's endpoint instance id
     * @param sender - bytes indicating the address of the sender
     *                 (bytes is used since the sender can be on an EVM or non-EVM chain)
     * @param libraryName - string indicating the library name
     * @param nonce - uint256 indicating the nonce of the message that was passed
     */
    event MessageDeliveredToApp(
        address indexed app, bytes32 indexed senderInstanceId, bytes sender, string libraryName, uint256 nonce
    );
}
