//
//  KeyboardPickerDemoView.swift
//  UILibrary
//
//  Created by Teddy on 2021/7/31.
//

import UIKit

class KeyboardPickerDemoView: UIView {

    // UI element
    lazy var normalField: UITextField = {
        let field = UITextField()
        field.textColor = .black
        field.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        field.placeholder = "請選擇項目"
        field.inputView = normalPickerView
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.gray.cgColor
        field.textAlignment = .center
        return field
    }()
    
    lazy var yearField: UITextField = {
        let field = UITextField()
        field.textColor = .black
        field.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        field.placeholder = "請選擇日期"
        field.inputView = yearPickerView
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.gray.cgColor
        field.textAlignment = .center
        return field
    }()
    
    let normalPickerView = KeyboardPickerView(pickerType: .normal, isNeedToolbar: true)
    
    let yearPickerView = KeyboardPickerView(pickerType: .monthYear, isNeedToolbar: true)

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

extension KeyboardPickerDemoView {

    func configer() {

    }
}

// MARK: - Setup UI

private extension KeyboardPickerDemoView {

    func setupUI() {

        addSubview(normalField)
        normalField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).inset(30)
            make.size.equalTo(CGSize(width: 180, height: 30))
        }
        
        addSubview(yearField)
        yearField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(normalField.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 180, height: 30))
        }
        
        backgroundColor = .white
    }
}
