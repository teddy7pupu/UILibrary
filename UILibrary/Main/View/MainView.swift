//
//  MainView.swift
//  UILibrary
//
//  Created by Teddy on 2021/7/31.
//

import UIKit
import SwifterSwift

class MainView: UIView {

    // UI element
    lazy var table: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.contentInset = .zero
        table.backgroundColor = .white
        table.separatorStyle = .none
        table.register(cellWithClass: MainCell.self)
        table.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        table.sectionFooterHeight = CGFloat.leastNormalMagnitude
        table.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        table.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        table.contentInset = .zero
        table.contentInsetAdjustmentBehavior = .never
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        return table
    }()

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

extension MainView {

    func configer() {

    }
}

// MARK: - Setup UI

private extension MainView {

    func setupUI() {

        addSubview(table)
        table.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide)
            make.right.left.bottom.equalToSuperview()
        }
        
        backgroundColor = .white
    }
}
