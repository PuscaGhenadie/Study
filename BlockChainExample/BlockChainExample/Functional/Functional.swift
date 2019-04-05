//
//  Functional.swift
//  BlockChainExample
//
//  Created by Pusca Ghenadie on 05/04/2019.
//  Copyright © 2019 Pusca Ghenadie. All rights reserved.
//

import Foundation

precedencegroup Group { associativity: left }

/// Combine two functions where both return nil
infix operator -->?: Group
/// Combine to simple functions
infix operator -->: Group
infix operator >>>: Group

func -->? <T, U, V>(left: @escaping (T) -> U?, right: @escaping (U) -> V?) -> (T) -> V? {
    return {
        guard let value = left($0) else {
            return nil
        }
        return right(value)
    }
}

func --> <T, U, V>(left: @escaping (T) -> U, right: @escaping (U) -> V) -> (T) -> V {
    return { right(left($0)) }
}

func --> <T, U>(f: @escaping (T) -> U, sideEffect: @escaping (U) -> Void) -> (T) -> U {
    return {
        let res = f($0)
        sideEffect(res)
        return res
    }
}

func >>> <T, U, V>(left: @escaping (T) throws -> U, right: @escaping (U) throws -> V) -> (T) throws -> V {
    return {
        return try right(left($0))
    }
}

func >>> <T, U>(f: @escaping (T) throws -> U, sideEffect: @escaping (U) -> Void) -> (T) throws -> U {
    return {
        let res = try f($0)
        sideEffect(res)
        return res
    }
}
