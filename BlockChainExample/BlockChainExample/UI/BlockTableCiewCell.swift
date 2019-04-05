//
//  BlockTableCiewCell.swift
//  BlockChainExample
//
//  Created by Pusca Ghenadie on 05/04/2019.
//  Copyright © 2019 Pusca Ghenadie. All rights reserved.
//

import UIKit

final class BlockTableCiewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let fromLabel: UILabel = UILabel()
        let toLabel = UILabel()
        let amountLabel = UILabel()
        let hashValueLabel = UILabel()
        let stack = UIStackView(arrangedSubviews: [fromLabel, toLabel, amountLabel, hashValueLabel])
        stack.axis = .horizontal
        contentView.addSubview(stack)
        stack.topAnchor.anchorWithOffset(to: contentView.topAnchor)
        stack.leadingAnchor.anchorWithOffset(to: contentView.leadingAnchor)
        stack.bottomAnchor.anchorWithOffset(to: contentView.bottomAnchor)
        stack.trailingAnchor.anchorWithOffset(to: contentView.trailingAnchor)
    }
    
    func update(block: Block) {
        // TODO
    }
}
