//
//  ThanosButtonDemoView.swift
//  UILibrary
//
//  Created by Teddy on 2021/8/5.
//

import UIKit

class ThanosButtonDemoView: UIView {

    // UI element
    private lazy var fillButton: ThanosButton = {
        var style = FillStyle()
        style.cornerRadius = 4
        style.fillNormalColor = .red
        style.fillPressedColor = UIColor.red.withAlphaComponent(0.6)
        style.fillDisableColor = .gray
        
        let button = ThanosButton(thanosStyle: style)
        button.setTitle("Fill", for: .normal)
        return button
    }()
    
    private lazy var outlineButton: ThanosButton = {
        var style = OutlineStyle()
        style.cornerRadius = 4
        style.borderWidth = 2
        style.outlineNormalColor = .red
        style.outlinePressedColor = UIColor.red.withAlphaComponent(0.6)
        style.outlineDisableColor = .gray
        style.textNormalColor = .red
        style.textPressedColor = UIColor.red.withAlphaComponent(0.6)
        
        let button = ThanosButton(thanosStyle: style)
        button.setTitle("Outline", for: .normal)
        return button
    }()
    
    private lazy var mixButton: ThanosButton = {
        var style = MixStyle()
        style.cornerRadius = 4
        style.scale = 0.9
        style.iconNormal = addNormal
        style.iconPressed = addPressed
        style.iconDisable = addDisabled
        style.aligned = .bottomToTop
        style.space = 5
        
        let button = ThanosButton(thanosStyle: style)
        button.setTitle("Mix", for: .normal)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 8
        view.addArrangedSubviews([fillButton, outlineButton, mixButton])
        return view
    }()
    
    // property
    private let addNormal = UIImage(named: "addNormal")
    private let addPressed = UIImage(named: "addPressed")
    private let addDisabled = UIImage(named: "addDisabled")

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

extension ThanosButtonDemoView {

    func configer() {

    }
}

// MARK: - Setup UI

private extension ThanosButtonDemoView {

    func setupUI() {

        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(30)
            make.right.left.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        backgroundColor = .white
    }
}
