//
//  MainCell.swift
//  UILibrary
//
//  Created by Teddy on 2021/7/31.
//

import UIKit
import SnapKit

class MainCell: UITableViewCell {

    // UI element
    private let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return lbl
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    // Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configer

extension MainCell {

    func configer(data: String) {

        titleLbl.text = data
    }
}

// MARK: - Setup UI

private extension MainCell {

    func setupUI() {

        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(8)
            make.height.equalTo(24)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(20)
            make.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        selectionStyle = .none
        backgroundColor = .clear
    }
}
