//
//  Operations.swift
//  BlockChainExample
//
//  Created by Pusca Ghenadie on 05/04/2019.
//  Copyright © 2019 Pusca Ghenadie. All rights reserved.
//

import Foundation
import CryptoSwift

typealias Key = String

struct Constants {
    static let defaultHash = "0000000000000000"
    static let startIndex = 0
    static let startNonce = 0
    static let workHashPrefix = "00"
}

// MARK: - Top functions
func initialBlock(_ transactions: [Transaction]) throws -> Block {
    return try (generateInitialKey >>> generateHash
        >>> {
            Block(index: Constants.startIndex,
                  previousHash: Constants.defaultHash,
                  hash: $0,
                  nonce: Constants.startNonce,
                  transactions: transactions)
        })(transactions)
    
}

func addBlock(to blocks: [Block], transactions: [Transaction]) throws -> [Block] {
    return try ({
        try getHash(blocks.count,
                    blocks.last?.hash ?? Constants.defaultHash,
                    Constants.startNonce,
                    transactions)
        } >>> {
            blocks + [Block(index: blocks.count,
                            previousHash: blocks.last?.hash ?? Constants.defaultHash,
                            hash: $0,
                            nonce: Constants.startNonce,
                            transactions: transactions)]
        })(())
}

// MARK: - Compute functions
func key(_ index: Index,
         _ previousHash: Hash,
         _ nonce: Nonce,
         _ transactions: [Transaction]) throws -> Key {
    return try (transactionData >>> transactionDataString >>> {
        return "\(index)" + previousHash + "\(nonce)" + $0
        })(transactions)
}

func generateInitialKey(_ transactions: [Transaction]) throws -> Key {
    return try key(Constants.startIndex, Constants.defaultHash, Constants.startNonce, transactions)
}

func getHash(_ index: Index,
             _ previousHash: Hash,
             _ nonce: Nonce,
             _ transactions: [Transaction]) throws -> Hash {
    return try ({
                    try key(index, previousHash, $0, transactions)
               } >>> generateHash
                 >>> { print("generated hash for block idx: \(index) -> \($0)") }
                 >>> {
                    if $0.hasPrefix(Constants.workHashPrefix) {
                        return $0
                    }
                    return try getHash(index, previousHash, nonce + 1, transactions)
        })(nonce)
}

func generateHash(for key: Key) throws -> Hash {
    return try (dataFromString >>> encryptedData >>> transactionDataString)(key)
}

// MARK: - Transform functions

enum Errors: Error {
    case failedToCreateStringFromData
    case failedToCreateDataFromString
}

func encryptedData(data: Data) -> Data {
    return data.sha1()
}

func dataFromString(str: String) throws -> Data {
    guard let data = str.data(using: .utf8) else {
        throw Errors.failedToCreateDataFromString
    }
    
    return data
}

func transactionData(tr: [Transaction]) throws -> Data {
    return try JSONEncoder().encode(tr)
}

func transactionDataString(data: Data) throws -> String {
    guard let str = String(data: data, encoding: .utf8) else {
        throw Errors.failedToCreateStringFromData
    }
    
    return str
}
