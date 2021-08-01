//
//  InfiniteLoopDemoView.swift
//  UILibrary
//
//  Created by Teddy on 2021/8/1.
//

import UIKit

class InfiniteLoopDemoView: UIView {

    // UI element
    typealias LoopView = InfiniteLoopView<UIColor, InfiniteLoopDemoCell>
    lazy var infiniteLoopView: LoopView = {
        let view = LoopView(
            itemSize: CGSize(width: UIScreen.main.bounds.width, height: 300))
        { (data, cell) in
            cell.configer(data: data)
        } pageIndexHandler: { (currentPage) in
            print("currentPage: \(currentPage)")
        } selectIndexHandler: { (selectIndex) in
            print("selectIndex: \(selectIndex)")
        }
        return view
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

extension InfiniteLoopDemoView {

    func configer() {

    }
}

// MARK: - Setup UI

private extension InfiniteLoopDemoView {

    func setupUI() {

        addSubview(infiniteLoopView)
        infiniteLoopView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(30)
            make.right.left.equalToSuperview()
            make.height.equalTo(300)
        }
        
        backgroundColor = .white
    }
}
