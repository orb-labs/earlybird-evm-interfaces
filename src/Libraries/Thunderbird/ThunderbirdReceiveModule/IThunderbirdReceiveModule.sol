// src/Libraries/Thunderbird/ThunderbirdReceiveModule/IThunderbirdReceiveModule.sol
// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.17;

/**
 * @author - Orb Labs
 * @title  - IThunderbirdReceiveModule
 * @notice - Interface for Thunderbird library's receive module only functions
 */
interface IThunderbirdReceiveModule {
    /**
     * @dev - Enum representing the types of app config updates that can be made
     * ORACLE_CHANGE - represents the app's oracle being updated.
     * RELAYER_CHANGE - represents the app's default relayer being updated.
     * RECS_CONTRACT_CHANGE - represents the app's default recommendations contract being updated.
     * MSG_PROOF_BROADCASTING_STATUS_CHANGE - represents the app's msg proof broadcast type being updated.
     * DIRECT_MSG_DELIVERY_STATUS_CHANGE - represents the app's direct msg delivery status being updated.
     * MSG_DELIVERY_PAUSED_STATUS_CHANGE - represents the app's msg delivery status being updated.
     * NONCE_CHANGE - represents the app's msg nonce being updated.
     */
    enum ConfigUpdateType {
        ORACLE_CHANGE,
        RELAYER_CHANGE,
        RECS_CONTRACT_CHANGE,
        MSG_PROOF_BROADCASTING_STATUS_CHANGE,
        DIRECT_MSG_DELIVERY_STATUS_CHANGE,
        MSG_DELIVERY_PAUSED_STATUS_CHANGE,
        NONCE_CHANGE
    }

    /**
     * @dev - Struct that represents an app config within the Thunderbird receive module
     * oracle - address of the oracle selected by the app to send proofs to the receiver's earlybird endpoint
     * defaultRelayer - address of app's default relayer.  The default relayer is typically responsible for passing
     *                  the app's messages unless the recs contract provides a different relayer
     * recsContract - address of the contract we can call for recommendations for the values we should pass with the msg proof.
     *                i.e. msg revealed secret, recommended relayer.
     * emitMsgProofs - bool indicating whether the protocol should broadcast contents of msg proofs when an oracle submits them.
     * directMsgsEnabled - bool indicating whether the receive module should deliver messages to the app directly or not.
     * msgDeliveryPaused - bool indicating whether msg delivery is paused or not. If paused, the library will not accept new msg
     *                     proofs or deliver messages to the app.
     */
    struct AppConfig {
        address oracle;
        address defaultRelayer;
        address recsContract;
        bool emitMsgProofs;
        bool directMsgsEnabled;
        bool msgDeliveryPaused;
    }

    /**
     * @dev - Struct that contains data that is encoded and hashed to create a msg proof
     * msgHash - byte32 indicating hash of the message being passed. Hash of the message emitted by the sender on the
     *           sender's earlybird endpoint instance in the order it was emitted.
     * revealedMsgSecret - bytes array indicating a revealed secret the oracle must reveal about the message proof
     *                     it is passing. Value can be retrived from calling the app's recsContract. Messages
     *                     with invalid revealed msg secrets can be rejected by the app. Can be used by third party's recommended
     *                     relayers to self-select which message proofs to pay attention to.
     * senderInstanceId - bytes32 indicating the sender's earlybird endpoint instance id.
     * isSelfBroadcastedMsg - bool indicating whether the message was self broadcasted or sent through the endpoint and broadcasted by the send library.
     * sender - bytes indicating the address of the sender. (bytes is used since the sender can be on an EVM or non-EVM chain)
     * sourceTxnHash - bytes indicating the source transaction hash
     */
    struct MsgProof {
        bytes32 msgHash;
        bytes32 revealedMsgSecret;
        bytes32 senderInstanceId;
        bool isSelfBroadcastedMsg;
        bytes sender;
        bytes sourceTxnHash;
    }

    /**
     * @dev - Struct used to pass msg proofs by app.  This struct is the argument for submitMsgProofs().
     *        Plays a major role in how message proofs are stored in the library.
     * app - address of app who the messages are being delivered to.
     * indexToWriteInto - uint256 indicating the index that the hash of msgProofs should be written to.
     * msgProofs - array of MsgProof Bytes representing message proofs for messages that are being sent to the app.
     */
    struct MsgProofsByApp {
        address app;
        uint256 indexToWriteInto;
        MsgProof[] msgProofs;
    }

    /**
     * @dev - Struct used to pass msg by app.  This struct is the argument for submitMessages().
     * app - address of app who the messages are being delivered to.
     * senderInstanceId - bytes32 indicating the index that the hash of msgProofs should be written to.
     * sender - array of MsgProof Bytes representing message proofs for messages that are being sent to the app.
     * msgsByAggregateProofs - array of msg proofs by aggregate proof hash.
     */
    struct MsgsByApp {
        address app;
        bytes32 senderInstanceId;
        bytes sender;
        MsgsByAggregateProof[] msgsByAggregateProofs;
    }

    /**
     * @dev - Struct used to pass msgs by aggregate proof.  This struct is a field in MsgsByApp which is used in submitMessages.
     * @param aggregateMsgProofHashIndex - uint256 indicating the index of the aggregate msg proof hash
     * @param msgProofHashes - array of bytes32 that indicate hash of msg proofs that were submitted and
     *                         used to create the aggregate msg proof hash
     * @param msgs - Array of MsgData that can be used to recreate msgs and their msg proofs.
     */
    struct MsgsByAggregateProof {
        uint256 aggregateMsgProofHashIndex;
        bytes32[] msgProofHashes;
        MsgData[] msgs;
    }

    /**
     * @dev - Struct used to pass msg data that be used to recreate msgs and their msg proofs.
     *        This struct is a field in MsgsByAggregateProof which is used in MsgsByApp which is used submitMessages.
     * @param individualMsgProofIndex - uint256 indicating the index of the msgs proof hash in the invidualMsgProofHashes
     *                                  array within MsgsByAggregateProof.
     * @param nonce - nonce of the msg
     * @param destinationGas - uint256 indicating the destination gas indicated by the app on the source.
     * @param revealedMsgSecret - bytes32 indicating the revealed msg secret that was provided when supplying the message proof.
     * @param isOrderedMsg - bool indicating whether the msg is an ordered msg or not.
     * @param isSelfBroadcastedMsg - bool indicating that a message is a self broadcasted msg or not.
     * @param relayerRecommendedGas - the amount of gas the relayer recommends the message should be passed with.  It cannot be less than destinationGas
     * @param sourceTxnHash - bytes indicating the source transaction hash for the message.
     *                        This is used to generate the msg proof hash
     * @param payload - bytes indicating the actual msg payload
     */
    struct MsgData {
        uint256 individualMsgProofIndex;
        uint256 nonce;
        uint256 destinationGas;
        bytes32 revealedMsgSecret;
        bool isOrderedMsg;
        bool isSelfBroadcastedMsg;
        uint256 relayerRecommendedGas;
        bytes sourceTxnHash;
        bytes payload;
    }

    /**
     * @dev - Event emitted when msg proofs are submitted
     * @param app - address of the app messages are being sent to.
     * @param indexWrittenTo - uint256 indicating the index the aggregate msg proof should be written into.
     * @param aggregateMsgProofsHash - bytes32 indicating the aggregate msg proof hash
     * @param msgProofs - array of MsgProof
     */
    event MsgProofsSubmitted(
        address indexed app,
        uint256 indexed indexWrittenTo,
        bytes32 indexed aggregateMsgProofsHash,
        MsgProof[] msgProofs
    );

    /**
     * @dev - Event emitted when msg proofs are submitted
     * @param app - address of the app messages are being sent to.
     * @param indexWrittenTo - uint256 indicating the index the aggregate msg proof should be written into.
     * @param aggregateMsgProofsHash - bytes32 indicating the aggregate msg proof hash
     */
    event MsgProofsSubmitted(
        address indexed app, uint256 indexed indexWrittenTo, bytes32 indexed aggregateMsgProofsHash
    );

    /**
     * @dev - Event emitted when msg are delivered
     * @param app - address indicating app that the message was sent to.
     * @param msgHash - Hash of the message that was delivered
     * @param gasUsed - uint256 indicating how much gas was used for delivering msg
     */
    event MsgGasUsed(address indexed app, bytes32 indexed msgHash, uint256 gasUsed);

    /**
     * @dev - Function that allows an app's oracle to submit message proofs.
     * @param _msgProofsByApp - Array of msg proofs by app.
     */
    function submitMessageProofs(MsgProofsByApp[] memory _msgProofsByApp) external payable;

    /**
     * @dev - Function that allows an app's relayer to submit messages.
     * @param _msgsByApps - Array of msgs by app.
     */
    function submitMessages(MsgsByApp[] memory _msgsByApps) external payable;
}
