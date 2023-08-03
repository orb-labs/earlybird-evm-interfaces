// src/Libraries/Rukh/RukhSendModule/IRukhSendModule.sol
// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.17;

import "../../ILibrary/IRequiredSendModuleFunctions.sol";

/**
 * @author - Orb Labs
 * @title  - IRukhSendModule
 * @notice - Interface for Rukh library's send module
 */
interface IRukhSendModule is IRequiredSendModuleFunctions {
    /**
     * @dev - Enum representing config type the app would like updated.
     * BROADCAST_STATUS_CHANGE - represents broadcasting status being updated
     * ORACLE_CHANGE - represents oracle address being updated
     * RELAYER_CHANGE - represents relayer address being updated
     * NONCE_CHANGE - represents the app's msg nonce being updated.
     */
    enum ConfigType {
        BROADCAST_STATUS_CHANGE,
        ORACLE_CHANGE,
        RELAYER_CHANGE,
        NONCE_CHANGE
    }

    /**
     * @dev - Struct that represent protocol fee settings
     * feeOn - bool indicating whether protocol fees are on
     * feeTo - address indicating who protocol fees should be paid to.
     * collectInNativeToken - bool indicaitng whether protocol fees should be collected in native token.
     * nonNativeFeeToken - address indicating what non-native token protocol fees should be collected in if applicable.
     * amount - uint256 indicating amount of tokens that should be collected as fees.
     */
    struct ProtocolFeeSettings {
        bool feeOn;
        address payable feeTo;
        bool collectInNativeToken;
        address nonNativeFeeToken;
        uint256 amount;
    }

    /**
     * @dev - Struct representing an app's settings
     * isSelfBroadcasting - bool on whether the app is self broadcasting or not.
     * oracleFeeCollector - address to which the app will pay oracle fees
     * relayerFeeCollector - address to which the app will pay relayer fees
     */
    struct AppSettings {
        bool isSelfBroadcasting;
        address oracleFeeCollector;
        address relayerFeeCollector;
    }

    /**
     * @dev - Struct representing an app's settings
     * ordered - uint256 indicating nonce for ordered messages.  Starts from 0 and goes to 2**256 – 1.
     * unordered - uint256 indicating nonce for unordered messages. Starts from 2**256 – 1 and goes to 0.
     */
    struct Nonces {
        uint256 ordered;
        uint256 unordered;
    }

    /**
     * @dev - Struct representing additional params sent to protocol during the send call.
     * address feeToken - address of the token being used to pay fees.
     * isOrderedMsg - bool indicating whether the message is an ordered msg or not.
     * destinationGas - uint256 indicating the gas to deliver the message with on the destination
     */
    struct AdditionalParams {
        address feeToken;
        bool isOrderedMsg;
        uint256 destinationGas;
    }

    /**
     * @dev - Event emitted when you send a message
     * @param nonce - uint256 indicating the nonce of the message. The nonce is a unique number given to each message.
     * @param sender - address of the sender
     * @param senderInstanceId - bytes32 indicating the sender's earlybird endpoint instance Id.
     * @param receiver - bytes array indicating the address of the receiver
     * @param receiverInstanceId - bytes32 indicating the receiver's earlybird endpoint instance Id
     * @param isOrderedMsg - bool indicating whether message must be delivered in order or not.
     * @param destinationGas - uint256 indicating the amount of gas that the message should be delivered with on the destination.
     * @param payload - bytes array containing message payload
     * @param libraryId - uint256 indicating the library Id
     */
    event BroadcastMessage(
        uint256 indexed nonce,
        address indexed sender,
        bytes32 senderInstanceId,
        bytes receiver,
        bytes32 receiverInstanceId,
        bool isOrderedMsg,
        uint256 destinationGas,
        bytes payload,
        uint256 libraryId
    );

    /**
     * @dev - Event emitted when you self broadcast a message
     * @param nonce - uint256 indicating the nonce of the message. The nonce is a unique number given to each message.
     * @param senderInstanceId - bytes32 indicating the sender's endpoint instance Id.
     * @param receiver - bytes array indicating the address of the receiver
     * @param receiverInstanceId - bytes32 indicating the receiver's endpoint instance Id
     * @param isOrderedMsg - bool indicating whether message must be delivered in order or not.
     * @param destinationGas - uint256 indicating the amount of gas that the message should be delivered with on the destination.
     * @param payload - bytes array containing message payload
     * @param libraryId - uint256 indicating the library Id
     */
    event SelfBroadcastMessage(
        uint256 indexed nonce,
        bytes32 senderInstanceId,
        bytes receiver,
        bytes32 receiverInstanceId,
        bool isOrderedMsg,
        uint256 destinationGas,
        bytes payload,
        uint256 libraryId
    );

    /**
     * @dev - Event emitted when you self broadcast a message
     * @param msgHash - hash of the msg that the app delivered
     * @param oracleFeeCollector - address to which oracle fees were paid
     * @param relayerFeeCollector - address to which relayer fees were paid
     * @param feeToken - token that the fee was paid in
     * @param oracleFee - fee paid to the oracle
     * @param relayerFee - fee paid to the relayer
     */
    event OracleAndRelayerPaid(
        bytes32 indexed msgHash,
        address indexed oracleFeeCollector,
        address indexed relayerFeeCollector,
        address feeToken,
        uint256 oracleFee,
        uint256 relayerFee
    );
}
