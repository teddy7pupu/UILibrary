//
//  KeyboardPickerView.swift
//  UILibrary
//
//  Created by Teddy on 2021/7/31.
//

import UIKit

enum PickerType {
    case normal
    case monthYear
}

class KeyboardPickerView: UIView {
    
    // UI element
    private lazy var toolbar: UIToolbar = {
        let spaceBarItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDone))
        let toolbar = UIToolbar(frame: .zero)
        toolbar.items = [spaceBarItem, doneBarItem]
        return toolbar
    }()
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    // property
    
    /// picker 類別
    private let pickerType: PickerType
    
    /// 是否需要顯示 toolbar
    private let isNeedToolbar: Bool
    
    /// 點擊完成後的 call back
    private let tapDoneHandler: (() -> Void)?
    
    /// 當前選擇文字
    private var currentSelectText: String?
    
    /// pickerType - monthYear 單位, ex: 2021.07
    private var unit: String = "."
    
    /// pickerType - monthYear 顯示年份
    private let years: [String] = {
        let currentYear: Int = Calendar.current.component(.year, from: Date())
        var years = [String]()
        for count in (currentYear-4)...currentYear { years.append("\(count)") }
        return years
    }()
    
    /// pickerType - monthYear 顯示月份
    private let months: [String] = [
        "01", "02", "03", "04", "05", "06",
        "07", "08", "09", "10", "11", "12"
    ]
    
    weak var owner: UITextField?
    
    /// pickerType - normal 輸入資料陣列
    var dataSource: [String]? {
        didSet {
            if currentSelectText == nil { currentSelectText = dataSource?.first }
            pickerView.reloadAllComponents()
        }
    }
    
    // Life cycle
    init(pickerType: PickerType,
         isNeedToolbar: Bool,
         tapDoneHandler: (() -> Void)? = nil) {
        
        self.pickerType = pickerType
        self.isNeedToolbar = isNeedToolbar
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

extension KeyboardPickerView {

    func configer() {

        switch pickerType {
        case .normal:
            break
        case .monthYear:
            guard let year = years.first, let month = months.first else { return }
            currentSelectText = "\(year)\(unit)\(month)"
        }
    }
}

// MARK: - Active

extension KeyboardPickerView {
    
    /// 點擊完成
    @objc private func onDone() {
        
        owner?.text = currentSelectText
        owner?.sendActions(for: .editingChanged)
        owner?.resignFirstResponder()
        
        tapDoneHandler?()
    }
    
    /// 校正 picker 預設選擇項目
    func correction() {
        guard let ownerText = owner?.text else { return }
        
        switch pickerType {
        case .normal:
            guard let _dataSource = dataSource,
                let selectIndex = _dataSource.firstIndex(of: ownerText)
                else { return }
            
            pickerView.selectRow(selectIndex, inComponent: 0, animated: true)
            currentSelectText = _dataSource[selectIndex]
        case .monthYear:
            let yearMonthText = ownerText.split(separator: Character(unit))
            guard let yearText = yearMonthText.first,
                let monthText = yearMonthText.last,
                let yearTextIndex = years.firstIndex(of: String(yearText)),
                let monthTextIndex = months.firstIndex(of: String(monthText))
                else { return }
            
            pickerView.selectRow(yearTextIndex, inComponent: 0, animated: true)
            pickerView.selectRow(monthTextIndex, inComponent: 1, animated: true)
            
            let year = years[pickerView.selectedRow(inComponent: 0)]
            let month = months[pickerView.selectedRow(inComponent: 1)]
            
            currentSelectText = "\(year)\(unit)\(month)"
        }
    }
}

// MARK: - UIPickerViewDelegate

extension KeyboardPickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let text: String?
        switch pickerType {
        case .normal:
            guard let _dataSource = dataSource else { return }
            text = _dataSource[pickerView.selectedRow(inComponent: 0)]
        case .monthYear:
            let month = months[pickerView.selectedRow(inComponent: 1)]
            let year = years[pickerView.selectedRow(inComponent: 0)]
            text = "\(year)\(unit)\(month)"
        }
        
        switch isNeedToolbar {
        case true:
            currentSelectText = text
        case false:
            owner?.text = text
            owner?.sendActions(for: .editingChanged)
        }
    }
}

// MARK: - UIPickerViewDataSource

extension KeyboardPickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        switch pickerType {
        case .normal:
            return 1
        case .monthYear:
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerType {
        case .normal:
            return dataSource?.count ?? 0
        case .monthYear:
            return (component == 0) ? years.count : months.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerType {
        case .normal:
            guard let _dataSource = dataSource else { return nil }
            return _dataSource[row]
        case .monthYear:
            return (component == 0) ? years[row] : months[row]
        }
    }
}

// MARK: - Setup UI

private extension KeyboardPickerView {

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
