// src/EarlybirdEndpoint/IEarlybirdEndpointFunctionsForAdmins.sol
// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.17;

/**
 * @author - Orb Labs
 * @title  - IEarlybirdEndpointFunctionsForAdmins
 * @notice - Interface for Earlybird Endpoint functions only the admin can call
 */
interface IEarlybirdEndpointFunctionsForAdmins {
    /**
     * @dev - Admin-only function that adds a new message library to the endpoint
     * @param _libraryName - string of the name of the library that is being added
     * @param _sendModule - address of the module responsible for sending messages
     * @param _receiveModule - address of the module responsible for receiving messages
     */
    function addNewLibrary(string calldata _libraryName, address _sendModule, address _receiveModule) external;

    /**
     * @dev - Admin-only function that allows endpoint admin to pause a library
     * @param _libraryName - string of the name of the library that is being paused
     */
    function pauseLibrary(string calldata _libraryName) external;

    /**
     * @dev - Admin-only function that allows endpoint admin to unpause a library
     * @param _libraryName - string of the name of the library that is being unpaused
     */
    function unpauseLibrary(string calldata _libraryName) external;

    /**
     * @dev - Admin-only function that adds a new inbound message library to the endpoint
     * @param _libraryName - string of the name of the library that is being deprecated
     */
    function deprecateLibrary(string calldata _libraryName) external;

    /**
     * @dev - Admin-only function that adds a new inbound message library to the endpoint
     * @param _libraryName - string of the name of the library that is being undeprecated
     */
    function undeprecateLibrary(string calldata _libraryName) external;

    /**
     * @dev - Admin-only function that allows admin to update library module settings
     * @param _libraryName - string of the name of the library that is being added
     * @param _moduleType - uint256 indicating whether its the sendModule or
     *                      receiveModule whose settings are being updated
     * @param _libraryModuleSettings - bytes value indicating the encoded library module settings
     */
    function updateLibraryModuleSettings(
        string calldata _libraryName,
        uint256 _moduleType,
        bytes calldata _libraryModuleSettings
    ) external;
}
