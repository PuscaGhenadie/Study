//
//  ViewController.swift
//  BlockChainExample
//
//  Created by Pusca Ghenadie on 05/04/2019.
//  Copyright © 2019 Pusca Ghenadie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var blockChain = [Block]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    func addInitialBlock(transactions: [Transaction]) {
        do {
            let block = try initialBlock([])
            blockChain.append(block)
        } catch {
            print("Failed to get initial block \(error.localizedDescription)")
        }
    }
    
    func insertBlock(forTransactions transactions: [Transaction]) {
        do {
            blockChain = try addBlock(to: blockChain, transactions: transactions)
        } catch {
            print("Failed to add block \(error.localizedDescription)")
        }
    }
}

