// src/ILibrary/IRequiredModuleFunctions.sol
// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.17;

/**
 * @author - Orb Labs
 * @title  - IRequiredModuleFunctions
 * @notice - Interface for required functions for all library modules.
 *           These fuunctions are required becaused they are called by the earlybird endpoint.
 */
interface IRequiredModuleFunctions {
    /**
     * @dev - Struct representing additional params sent to protocol during the send call.
     * address feeToken - address of the token being used to pay fees.
     * isOrderedMsg - bool indicating whether the message is an ordered msg or not.
     * destinationGas - uint256 indicating the gas to deliver the message with on the destination
     * expectedRelayer - address indicating the fee collector for the expected relayer on the destination.
     *                   If the expected relayer is the default relayer, supply address(0) or the default relayer fee collector.
     *                   If its anyone else, supply their fee collector.
     */
    struct AdditionalParams {
        address feeToken;
        bool isOrderedMsg;
        uint256 destinationGas;
        address expectedRelayerFeeCollector;
    }

    /**
     * @dev - Endpoint-only function that allows earlybird endpoint to pause library
     */
    function pauseLibrary() external;

    /**
     * @dev - Endpoint-only function that allows erlybird endpoint to unpause library
     */
    function unpauseLibrary() external;

    /**
     * @dev - Endpoint-only function that allows earlybird endpoint to get the id of the library
     */
    function getLibraryId() external returns (uint256 libraryId);

    /**
     * @dev - Endpoint-only function that allows earlybird endpoint to pass application configs to the library
     * @param _app - address of application passing the configs
     * @param _configs - bytes array containing encoded configs to be passed
     *                   to the library on the applications behalf
     */
    function setAppConfigs(address _app, bytes memory _configs) external;

    /**
     * @dev - Endpoint-only function that allows earlybird endpoint to retrieve an application configs in a library
     * @param _app - address of application passing the configs
     */
    function getAppConfigs(address _app) external view returns (bytes memory);

    /**
     * @dev - Endpoint-only function that allows earlybird endpoint to update an application's library configs
     * @param _app - address of application passing the configs
     * @param _configs - bytes array containing encoded configs to be passed
     *                   to the library on the applications behalf
     */
    function updateAppConfigs(address _app, bytes memory _configs) external;

    /**
     * @dev - Endpoint-only function that allows earlybird endpoint to update settings for a library module.
     * @param _libraryModuleSettings - bytes array containing encoded earlybird endpoint library module settings.
     */
    function updateLibraryModuleSettings(bytes memory _libraryModuleSettings) external;

    /**
     * @dev - Endpoint-only function that allows earlybird endpoint to retrieve the library's modules settings.
     * @return libraryModuleSettings - bytes array containing encoded library module settings
     */
    function getLibraryModuleSettings() external view returns (bytes memory libraryModuleSettings);

    /**
     * @dev - Endpoint-only function that allows earlybird endpoint to retrieve the library's fee settings.
     * @return isProtocolFeeOn - boolean that says whether the protocol fee is on or not.
     * @return protocolFeeToken - address of the protocol fee token.
     *                            returns address(0) if fee is in native token.
     * @return protocolFeeAmount - uint256 indicating the fee amount
     */
    function getProtocolFee()
        external
        view
        returns (bool isProtocolFeeOn, address protocolFeeToken, uint256 protocolFeeAmount);

    // event that indicates that the library has been paused.
    event LibraryPaused(address indexed sender);

    // event that indicates that the library has been unpaused.
    event LibraryUnpaused(address indexed sender);
}
