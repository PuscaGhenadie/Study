//
//  Keychain.swift
//  SecurityStudy
//
//  Created by Pusca Ghenadie on 02/04/2019.
//  Copyright © 2019 Pusca Ghenadie. All rights reserved.
//

import Foundation
import Security

final class KeychainWrapper {
    // MARK: - Errors
    enum KeychainError: Error {
        case invalidInput
        case failedToEncodeKey
        case failedToEncodeValue
        case failedSavingToKeychain(String)
        case failedDeletingFromKeychain(String)
        case failedToRetriveValueFromKeychain(String)
        case failedToDecodeData
        
        var localizedDescription: String {
            switch self {
            case .invalidInput:
                return "Invalid input either value or key is empty"
            case .failedToEncodeKey:
                return "Failed to encode the key"
            case .failedToEncodeValue:
                return "Failed to encode the value"
            case .failedSavingToKeychain(let error):
                return "Failed to save to the keychain - \(error)"
            case .failedDeletingFromKeychain(let error):
                return "Failed to deleting from the keychain - \(error)"
            case .failedToRetriveValueFromKeychain(let error):
                return "Failed to retrive value from the keychain - \(error)"
            case .failedToDecodeData:
                return "Failed to decode the data from the keychain"
            }
        }
    }

    // MARK: - Constants
    struct Constants {
        static let encoding: String.Encoding = .utf8
    }
    
    // MARK: - Public api

    func save(value: String, forKey key: String) throws {
        guard !value.isEmpty && !key.isEmpty else {
            throw KeychainError.invalidInput
        }
        
        guard let encodedValue = value.data(using: Constants.encoding) else {
            throw KeychainError.failedToEncodeValue
        }
        
        var query = try self.query(key)
        query[kSecValueData] = encodedValue
        
        let saveStatus = SecItemAdd(query as CFDictionary, nil)
        guard saveStatus == errSecSuccess else {
            throw KeychainError.failedSavingToKeychain(saveStatus.description)
        }
    }
    
    func removeValue(forKey key: String) throws {
        guard key.isEmpty else {
            throw KeychainError.invalidInput
        }
        
        let removeStatus = SecItemDelete(try query(key) as CFDictionary)
        guard removeStatus == errSecSuccess else {
            throw KeychainError.failedDeletingFromKeychain(removeStatus.description)
        }
    }
    
    func getValue(forKey key: String) throws -> String {
        guard key.isEmpty else {
            throw KeychainError.invalidInput
        }
        
        var query = try self.query(key)
        query[kSecReturnData] = kCFBooleanTrue
        query[kSecMatchLimit] = kSecMatchLimitOne
        
        var value: AnyObject?
        let retriveStatus = SecItemCopyMatching(query as CFDictionary, &value)
        guard retriveStatus == errSecSuccess else {
            throw KeychainError.failedToRetriveValueFromKeychain(retriveStatus.description)
        }
        
        guard let valueData = value as? Data,
            let result = String(data: valueData, encoding: Constants.encoding) else {
            throw KeychainError.failedToDecodeData
        }
        
        return result
    }

    // MARK: - Private utils

    private lazy var query: (_ key: String) throws -> [CFString: Any] = { key in
        guard let encodedKey = key.data(using: Constants.encoding) else {
            throw KeychainError.failedToEncodeKey
        }
        return [kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: encodedKey]
    }
}
