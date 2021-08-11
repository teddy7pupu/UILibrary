//
//  ThanosButtonDemoViewController.swift
//  UILibrary
//
//  Created by Teddy on 2021/8/5.
//

import UIKit

class ThanosButtonDemoViewController: BaseViewController {

    // UI element
    private let thanosButtonDemoView = ThanosButtonDemoView()

    // property

    // Life cycle
    override func loadView() {
        
        view = thanosButtonDemoView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configer()
    }
}

// MARK: - Configer

private extension ThanosButtonDemoViewController {
        
    func configer() {
        
    }
}

// MARK: - Action

private extension ThanosButtonDemoViewController {

}

// MARK: - Getter

private extension ThanosButtonDemoViewController {

}
