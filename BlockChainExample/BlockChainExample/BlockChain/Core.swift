//
//  Core.swift
//  BlockChainExample
//
//  Created by Pusca Ghenadie on 05/04/2019.
//  Copyright © 2019 Pusca Ghenadie. All rights reserved.
//

import Foundation

typealias From = String
typealias To = String
typealias Amount = Double

typealias Index = Int
typealias Hash = String
typealias Nonce = Int

struct Transaction: Codable {
    let from: From
    let to: To
    let amount: Amount
}

struct Block {
    let index: Index
    let previousHash: Hash
    let hash: Hash
    let nonce: Nonce
    let transactions: [Transaction]
}

struct BlockChain {
    let blocks: [Block]
}
