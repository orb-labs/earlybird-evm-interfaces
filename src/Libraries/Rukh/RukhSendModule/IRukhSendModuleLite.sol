// src/Libraries/Rukh/RukhSendModule/IRukhSendModuleLite.sol
// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.17;

import "./IRukhSendModule.sol"
import "../../SharedLibraryModules/ISharedSendModuleLiteOnly.sol";

/**
 * @author - Orb Labs
 * @title  - IRukhSendModuleLite
 * @notice - Interface for Rukh library's send module lite version
 */
interface IRukhSendModuleLite is IRukhSendModule, ISharedSendModuleLiteOnly {}
