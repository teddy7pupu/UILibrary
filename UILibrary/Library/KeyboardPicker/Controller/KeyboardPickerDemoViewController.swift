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
    
    /// picker 輸入資料
    private let pickerDataSource = ["1", "2", "3", "4", "5"]

    /// date picker 日期設定
    private let defaultDate = Date()
    private let minDate = Date().adding(.day, value: -5)
    private let maxDate = Date().adding(.day, value: 5)
    
    // Life cycle
    override func loadView() {
        
        view = keyboardPickerDemoView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configer()
    }
}

// MARK: - Configer

private extension KeyboardPickerDemoViewController {
        
    func configer() {
        
        keyboardPickerDemoView.normalField.delegate = self
        keyboardPickerDemoView.yearField.delegate = self
        keyboardPickerDemoView.dateField.delegate = self
        
        keyboardPickerDemoView.normalPickerView.dataSource = pickerDataSource
        
        keyboardPickerDemoView.datePickerView.date = defaultDate
        keyboardPickerDemoView.datePickerView.minDate = minDate
        keyboardPickerDemoView.datePickerView.maxDate = maxDate
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
        case keyboardPickerDemoView.yearField:
            keyboardPickerDemoView.yearPickerView.owner = textField
        case keyboardPickerDemoView.dateField:
            keyboardPickerDemoView.datePickerView.owner = textField
        default:
            break
        }
    }
}
