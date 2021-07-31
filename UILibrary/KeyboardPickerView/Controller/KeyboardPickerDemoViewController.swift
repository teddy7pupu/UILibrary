//
//  KeyboardPickerDemoViewController.swift
//  UILibrary
//
//  Created by Teddy on 2021/7/31.
//

import UIKit

class KeyboardPickerDemoViewController: BaseViewController {

    // UI element
    private let keyboardPickerDemoView = KeyboardPickerDemoView()

    // property
    private let pickerDataSource = ["1", "2", "3", "4", "5"]

    // Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configer()
    }
}

// MARK: - Configer

private extension KeyboardPickerDemoViewController {
        
    func configer() {
        
        view = keyboardPickerDemoView
        
        keyboardPickerDemoView.normalField.delegate = self
        keyboardPickerDemoView.yearField.delegate = self
    }
}

// MARK: - Action

private extension KeyboardPickerDemoViewController {

}

// MARK: - Getter

private extension KeyboardPickerDemoViewController {

}

// MARK: - UITextFieldDelegate

extension KeyboardPickerDemoViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
        case keyboardPickerDemoView.normalField:
            keyboardPickerDemoView.normalPickerView.owner = textField
            keyboardPickerDemoView.normalPickerView.dataSource = pickerDataSource
        case keyboardPickerDemoView.yearField:
            keyboardPickerDemoView.yearPickerView.owner = textField
        default:
            break
        }
    }
}
