//
//  BaseViewController.swift
//  UILibrary
//
//  Created by Teddy on 2021/7/31.
//

import UIKit

class BaseViewController: UIViewController {

    // UI element

    // property

    // Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configer()
    }
}

// MARK: - Configer

private extension BaseViewController {
        
    func configer() {
        
        view.backgroundColor = .white
    }
}

// MARK: - Action

private extension BaseViewController {

}

// MARK: - Getter

private extension BaseViewController {

}
