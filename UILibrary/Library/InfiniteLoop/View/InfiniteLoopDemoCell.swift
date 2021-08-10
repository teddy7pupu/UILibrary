//
//  InfiniteLoopDemoCell.swift
//  UILibrary
//
//  Created by Teddy on 2021/8/1.
//

import UIKit

class InfiniteLoopDemoCell: UICollectionViewCell {

    // UI element

    // Life cycle
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configer

extension InfiniteLoopDemoCell {

    func configer(data: UIColor) {

        contentView.backgroundColor = data
    }
}

// MARK: - Setup UI

private extension InfiniteLoopDemoCell {

    func setupUI() {

    }
}
