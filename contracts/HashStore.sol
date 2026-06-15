// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * HashStore — SafeSplit's immutability contract.
 *
 *   - record(eventId, hash) : anchor a fingerprint for an event.
 *   - get(eventId)          : read back the anchored fingerprint.
 *
 * Once recorded, a fingerprint can never be overwritten (require below).
 * That is the immutability promise: not even an admin can rewrite history.
 */
contract HashStore {
    // eventId => anchored fingerprint
    mapping(bytes32 => bytes32) private hashes;

    event HashRecorded(bytes32 indexed eventId, bytes32 hash);

    function record(bytes32 eventId, bytes32 hash) external {
        bytes32 existing = hashes[eventId];

        // Idempotent (D4): re-recording the SAME hash is a no-op; a DIFFERENT hash is rejected.
        // This keeps immutability while letting multiple anchorers retry safely.
        require(
            existing == bytes32(0) || existing == hash,
            "A different fingerprint is already recorded for this eventId"
        );

        if (existing == bytes32(0)) {
            hashes[eventId] = hash;
            emit HashRecorded(eventId, hash);
        }
    }

    function get(bytes32 eventId) external view returns (bytes32) {
        return hashes[eventId];
    }
}
