//
//  KeychainConsumer.swift
//  SecurityStudy
//
//  Created by Pusca Ghenadie on 02/04/2019.
//  Copyright © 2019 Pusca Ghenadie. All rights reserved.
//

import Foundation

// Example consumer of the keychain
class KeychainConsumer {
    struct Keys {
        static let userNameKey = "username"
        static let password = "password"
    }

    private lazy var keychain = KeychainWrapper()

    func saveData() {
        let userName = "John Doe"
        let userPassword = "IAmBatman"
        
        executeKeychainOp {
            try keychain.save(value: userName, forKey: Keys.userNameKey)
            try keychain.save(value: userPassword, forKey: Keys.password)
        }
    }
    
    func removeData() {
        executeKeychainOp {
            try keychain.removeValue(forKey: Keys.password)
        }
    }
    
    func getData() {
        executeKeychainOp {
            let result = try keychain.getValue(forKey: Keys.password)
            print(result)
        }
    }
    
    private func executeKeychainOp(op: () throws -> ()) {
        do {
            try op()
        } catch let error as KeychainWrapper.KeychainError {
            print("Keychain error - \(error.localizedDescription)")
        } catch {
            print("Keychain generic error")
        }
    }
}
