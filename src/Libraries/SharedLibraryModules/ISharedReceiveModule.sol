// src/Libraries/SharedLibraryModules/ISharedReceiveModule.sol
// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.17;

import "../ILibrary/IRequiredReceiveModuleFunctions.sol";

/**
 * @author - Orb Labs
 * @title  - ISharedReceiveModule
 * @notice - Interface for a shared receive module for the Rukh and Thunderbird libraries
 */
interface ISharedReceiveModule is IRequiredReceiveModuleFunctions {
    /**
     * @dev - Struct that represent the library module settings
     * feeOn - bool indicating whether protocol fees are on
     * feeTo - address indicating who protocol fees should be paid to.
     * collectInNativeToken - bool indicaitng whether protocol fees should be collected in native token.
     * nonNativeFeeToken - address indicating what non-native token protocol fees should be collected in if applicable.
     * amount - uint256 indicating amount of tokens that should be collected as fees.
     */
    struct LibraryModuleSettings {
        bool feeOn;
        address payable feeTo;
        bool collectInNativeToken;
        address nonNativeFeeToken;
        uint256 amount;
    }

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

    /**
     * @dev - Emitted when two aggregate msg proof hashes are merged
     * @param app - address of the app msg proofs are being merged.
     * @param firstAggregateMsgProofHashIndex - uint256 indicating the index of the first aggregate msg proof index.
     * @param secondAggregateMsgProofHashIndex - uint256 indicating the index of the second aggregate msg proof index.
     * @param msgProofsInFirstAggregateMsgProofHash - bytes32 array indicating the msg proofs in first aggregate msg proof.
     * @param msgProofsInSecondAggregateMsgProofHash - bytes32 array indicating the msg proofs in second aggregate msg proof.
     */
    event MergedAggregateMsgProofHashes(
        address indexed app,
        uint256 indexed firstAggregateMsgProofHashIndex,
        uint256 indexed secondAggregateMsgProofHashIndex,
        bytes32[] msgProofsInFirstAggregateMsgProofHash,
        bytes32[] msgProofsInSecondAggregateMsgProofHash
    );

    /**
     * @dev - Emitted when two aggregate msg proof hashes are merged
     * @param app - address of the app msg proofs are being merged.
     * @param aggregateMsgProofHash1Index - uint256 indicating aggregate msg proof hash 1's index
     * @param aggregateMsgProofHash2Index - uint256 indicating aggregate msg proof hash 2's index
     * @param aggregateMsgProofHash1 - bytes32 indicating aggregate msg proof hash 1.
     * @param aggregateMsgProofHash2 - bytes32 indicating aggregate msg proof hash 2.
     * @param msgProofsInAggregateMsgProofHash1 - bytes32 array indicating the msg proofs in aggregate msg proof hash 1
     * @param msgProofsInAggregateMsgProofHash2 - bytes32 array indicating the msg proofs in aggregate msg proof hash 2
     */
    event SplitAggregateMsgProofHash(
        address indexed app,
        uint256 indexed aggregateMsgProofHash1Index,
        uint256 indexed aggregateMsgProofHash2Index,
        bytes32 aggregateMsgProofHash1,
        bytes32 aggregateMsgProofHash2,
        bytes32[] msgProofsInAggregateMsgProofHash1,
        bytes32[] msgProofsInAggregateMsgProofHash2
    );

    /**
     * @dev - Emitted when some msg proofs in an aggregate msg proof hash are removed.
     * @param app - address of the app messages are being sent to.
     * @param aggregateMsgProofHashIndex - uint256 indicating the index that the aggregate msg proof is written into.
     * @param aggregateMsgProofHash - bytes32 indicating the aggregate msg proof hash.
     * @param msgProofsHashesInAggregateMsgProofHash - bytes32 array indicating the hashes of msg proofs in the
     *                                                 aggregate msg proof hash
     */
    event TrimmedAggregateMsgProofHash(
        address indexed app,
        uint256 indexed aggregateMsgProofHashIndex,
        bytes32 indexed aggregateMsgProofHash,
        bytes32[] msgProofsHashesInAggregateMsgProofHash
    );

    /**
     * @dev - Event emitted when a message being delivered fails.
     * @param app - address of the app message was being sent to.
     * @param msgHash - bytes32 indicating the msg's hash
     * @param senderInstanceId - bytes32 indicating the earlybird endpoint instance id of the sender
     * @param sender - bytes array indicating the address of the sender
     * @param nonce - uint256 indicating the nonce of the failed msg
     * @param payload - bytes array indicating the payload of the msg
     * @param additionalInfo - bytes array indicating additional info that was being passed along to the app.
     * @param failureFee - uint256 indicating the fee user must pay to resent message.
     */
    event MsgFailed(
        address indexed app,
        bytes32 indexed msgHash,
        bytes32 indexed senderInstanceId,
        bytes sender,
        uint256 nonce,
        bytes payload,
        bytes additionalInfo,
        uint256 failureFee
    );

    /**
     * @dev - Event emitted when a message being delivered fails because it was submitted with wrong rec values.
     * @param app - address of the app message was being sent to.
     * @param msgHash - bytes32 indicating the msg's hash
     * @param senderInstanceId - bytes32 indicating the earlybird endpoint instance Id of the sender
     * @param sender - bytes array indicating the address of the sender
     * @param nonce - uint256 indicating the nonce of the failed msg
     */
    event MsgSubmittedWithWrongRecValues(
        address indexed app, bytes32 indexed msgHash, bytes32 indexed senderInstanceId, bytes sender, uint256 nonce
    );

    /**
     * @dev - Event emitted when a message being delivered fails because it was submitted by wrong relayer.
     * @param app - address of the app message was being sent to.
     * @param msgHash - bytes32 indicating the msg's hash
     * @param senderInstanceId - bytes32 indicating the earlybird endpoint instance Id of the sender
     * @param sender - bytes array indicating the address of the sender
     * @param nonce - uint256 indicating the nonce of the failed msg
     */
    event MsgSubmittedByWrongRelayer(
        address indexed app, bytes32 indexed msgHash, bytes32 indexed senderInstanceId, bytes sender, uint256 nonce
    );

    /**
     * @dev - Function that allows app's oracle to merge the msg proofs in two aggregate msg proof hashes together.
     *        The final merged aggregate msg proof is stored in the same slot as the first aggregate msg proof.
     * @param _app - address of the app msg proofs are being merged.
     * @param _firstAggregateMsgProofHashIndex - uint256 indicating the index of the first aggregate msg proof index.
     * @param _secondAggregateMsgProofHashIndex - uint256 indicating the index of the second aggregate msg proof index.
     * @param _msgProofsInFirstAggregateMsgProofHash - bytes32 array indicating the msg proofs in first aggregate msg proof.
     * @param _msgProofsInSecondAggregateMsgProofHash - bytes32 array indicating the msg proofs in second aggregate msg proof.
     */
    function mergeAggregateMsgProofHashes(
        address _app,
        uint256 _firstAggregateMsgProofHashIndex,
        uint256 _secondAggregateMsgProofHashIndex,
        bytes32[] memory _msgProofsInFirstAggregateMsgProofHash,
        bytes32[] memory _msgProofsInSecondAggregateMsgProofHash
    ) external;

    /**
     * @dev - Function that allows app's oracle to splits the msg proofs in an aggregate msg proof hash into two
     *        seperate aggregate msg proof hashes holding subset of the original.
     * @param _app - address of the app msg proofs are being split.
     * @param _aggregateMsgProofIndex - uint256 indicating the index of the aggregate msg proof we are splitting.
     * @param _msgProofsInAggregateMsgProofHash - bytes32 array indicating the msg proofs in aggregate msg proof
     *                                            we are splitting.
     * @param _indicesOfMsgProofsToKeepInAggregateMsgProofHash - uint256 array indicating indices of msg proofs
     *                                                           to keep in the original aggregate Msg Proof Hash.
     * @param _indicesOfMsgProofsToPutInNewAggregateMsgProofHash - uint256 array indicating indices of msg proofs
     *                                                             to put in the new aggregate msg proof hash we are creating.
     * @param _newAggregateMsgProofHashIndex - uint256 indicating the index of the new aggregate msg proof hash we created
     */
    function splitAggregateMsgProofHashes(
        address _app,
        uint256 _aggregateMsgProofIndex,
        bytes32[] memory _msgProofsInAggregateMsgProofHash,
        uint256[] memory _indicesOfMsgProofsToKeepInAggregateMsgProofHash,
        uint256[] memory _indicesOfMsgProofsToPutInNewAggregateMsgProofHash,
        uint256 _newAggregateMsgProofHashIndex
    ) external;

    /**
     * @dev - Function that allows the app's oracle to trims/removes some message proofs that are in an aggregate msg hash.
     * @param _app - address of the app msg proofs are being merged.
     * @param _aggregateMsgProofHashIndex - uint256 indicating the index of the first aggregate msg proof index.
     * @param _msgProofsInAggregateMsgProofHash - bytes32 array indicating the msg proofs in first aggregate msg proof.
     * @param _indicesOfMsgProofsInNewAggregateMsgProofHash - uint256 indicating the index of the second aggregate msg proof index.
     */
    function trimMsgProofsInAggregateMsgProof(
        address _app,
        uint256 _aggregateMsgProofHashIndex,
        bytes32[] memory _msgProofsInAggregateMsgProofHash,
        uint256[] memory _indicesOfMsgProofsInNewAggregateMsgProofHash
    ) external;
}
