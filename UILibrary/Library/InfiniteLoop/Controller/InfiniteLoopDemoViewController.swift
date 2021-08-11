//
//  InfiniteLoopDemoViewController.swift
//  UILibrary
//
//  Created by Teddy on 2021/8/1.
//

import UIKit

class InfiniteLoopDemoViewController: BaseViewController {

    // UI element
    private let infiniteLoopDemoView = InfiniteLoopDemoView()

    // property
    private let dataSource: [UIColor] = [.blue, .yellow, .brown]

    // Life cycle
    override func loadView() {
        
        view = infiniteLoopDemoView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configer()
    }
}

// MARK: - Configer

private extension InfiniteLoopDemoViewController {
        
    func configer() {
        
        infiniteLoopDemoView.infiniteLoopView.inputDatas = dataSource
    }
}

// MARK: - Action

private extension InfiniteLoopDemoViewController {

}

// MARK: - Getter

private extension InfiniteLoopDemoViewController {

}
