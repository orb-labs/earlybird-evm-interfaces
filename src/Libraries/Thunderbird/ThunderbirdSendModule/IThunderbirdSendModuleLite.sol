// src/Libraries/Thunderbird/ThunderbirdSendModule/IThunderbirdSendModuleLite.sol
// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.17;

import "./IThunderbirdSendModule.sol";
import "../../SharedLibraryModules/ISharedSendModuleLiteOnly.sol";

/**
 * @author - Orb Labs
 * @title  - IThunderbirdSendModuleLite
 * @notice - Interface for Thunderbird library's send module lite version
 */
interface IThunderbirdSendModuleLite is IThunderbirdSendModule, ISharedSendModuleLiteOnly {}
