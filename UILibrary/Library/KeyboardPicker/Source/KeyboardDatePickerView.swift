//
//  KeyboardDatePickerView.swift
//  UILibrary
//
//  Created by Teddy on 2021/8/1.
//

import UIKit

class KeyboardDatePickerView: UIView {

    // UI element
    private lazy var toolbar: UIToolbar = {
        let spaceBarItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDone))
        
        let toolbar = UIToolbar(frame: .zero)
        toolbar.items = [spaceBarItem, doneBarItem]
        return toolbar
    }()
    
    private lazy var pickerView: UIDatePicker = {
        let pickerView = UIDatePicker()
        pickerView.datePickerMode = datePickerMode
        pickerView.locale = Locale(identifier: "zh_Hant_TW")
        pickerView.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        if #available(iOS 13.4, *) {
            pickerView.preferredDatePickerStyle = .wheels
        }
        return pickerView
    }()

    // property
    
    /// date picker mode
    private let datePickerMode: UIDatePicker.Mode
    
    private let isNeedToolbar: Bool
    
    private let tapDoneHandler: (() -> Void)?
    
    private let ownerDateFormat: String = "yyyy.MM.dd"
    
    private var currentSelectText: String?
    
    /// 所屬 textField
    weak var owner: UITextField?
    
    /// 最小日期
    var minDate: Date? = Date() {
        didSet {
            pickerView.minimumDate = minDate
        }
    }
    
    /// 最大日期
    var maxDate: Date? = Date() {
        didSet {
            pickerView.maximumDate = maxDate
        }
    }
    
    // 預設日期
    var date: Date = Date() {
        didSet {
            pickerView.date = date
            currentSelectText = date.string(withFormat: ownerDateFormat)
        }
    }
    
    // Life cycle
    init(datePickerMode: UIDatePicker.Mode = .date,
         isNeedToolbar: Bool,
         tapDoneHandler: (() -> Void)? = nil) {
        
        self.isNeedToolbar = isNeedToolbar
        self.datePickerMode = datePickerMode
        self.tapDoneHandler = tapDoneHandler
        
        let bottomHeight = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        let keyboardHeight = isNeedToolbar ? (bottomHeight + 259) : (bottomHeight + 215)
        
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: keyboardHeight))
        
        setupUI()
        configer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configer

extension KeyboardDatePickerView {

    func configer() {

    }
}

// MARK: - Active

extension KeyboardDatePickerView {
    
    /// 點擊完成
    @objc private func onDone() {
        
        owner?.text = currentSelectText
        owner?.sendActions(for: .editingChanged)
        owner?.resignFirstResponder()
        
        tapDoneHandler?()
    }
    
    /// picker 數值改變
    @objc private func datePickerChanged(){
                
        switch isNeedToolbar {
        case true:
            currentSelectText = pickerView.date.string(withFormat: ownerDateFormat)
        case false:
            owner?.text = pickerView.date.string(withFormat: ownerDateFormat)
        }
    }
}

// MARK: - Setup UI

private extension KeyboardDatePickerView {

    func setupUI() {

        switch isNeedToolbar {
        case true:
            addSubview(toolbar)
            toolbar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
            
            addSubview(pickerView)
            pickerView.frame = CGRect(x: 0, y: 45, width: UIScreen.main.bounds.width, height: 217)
        case false:
            addSubview(pickerView)
            pickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 217)
        }
    }
}
