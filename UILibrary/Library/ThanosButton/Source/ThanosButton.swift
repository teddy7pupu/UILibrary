//
//  ThanosButton.swift
//  iOS-UILib
//
//  Created by Teddy on 2020/3/3.
//  Copyright © 2020 GOONS. All rights reserved.
//

import UIKit

class ThanosButton: UIButton {
    
    // property
    var style: ThanosSettable
    
    // life cycle
    init(thanosStyle: ThanosSettable) {
        self.style = thanosStyle
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    // override property
    override var isEnabled: Bool {
        didSet {
            for buttonStyle in style.buttonStyles {
                switch buttonStyle {
                case .fill:
                    backgroundColor = isEnabled ? style.fillNormalColor : style.fillDisableColor
                case .outline:
                    layer.borderColor = isEnabled ? style.outlineNormalColor.cgColor : style.outlinePressedColor.cgColor
                default:
                    break
                }
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            for buttonStyle in style.buttonStyles {
                switch buttonStyle {
                case .fill:
                    backgroundColor = isHighlighted ? style.fillPressedColor : style.fillNormalColor
                case .outline:
                    layer.borderColor = isHighlighted ? style.outlinePressedColor.cgColor : style.outlineNormalColor.cgColor
                default:
                    break
                }
            }
            
            // 縮放時間
            UIView.animate(withDuration: 0.1) {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: self.style.scale, y: self.style.scale) : CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    // setupUI
    private func setupUI() {
        
        titleLabel?.font = style.textFont
        
        layer.cornerRadius = style.cornerRadius
        
        for buttonStyle in style.buttonStyles {
            switch buttonStyle {
            case .fill:
                backgroundColor = isEnabled ? style.fillNormalColor : style.fillDisableColor
            case .outline:
                layer.borderWidth = style.borderWidth
                layer.borderColor = isEnabled ? style.outlineNormalColor.cgColor : style.outlineDisableColor?.cgColor
            case .text:
                setTitleColor(style.textNormalColor, for: .normal)
                setTitleColor(style.textPressedColor, for: .highlighted)
                setTitleColor(style.textDisableColor, for: .disabled)
            case .icon:
                setBackgroundImage(style.iconNormal, for: .normal)
                setBackgroundImage(style.iconPressed, for: .highlighted)
                setBackgroundImage(style.iconDisable, for: .disabled)
            case .textIcon:
                setTitleColor(style.textNormalColor, for: .normal)
                setTitleColor(style.textPressedColor, for: .highlighted)
                setTitleColor(style.textDisableColor, for: .disabled)
                
                setImage(style.iconNormal, for: .normal)
                setImage(style.iconPressed, for: .highlighted)
                setImage(style.iconDisable, for: .disabled)
                
                layoutIfNeeded()
                let titleFrame = titleLabel?.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
                let imageFrame = imageView?.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
                let space = style.space / 2
                
                switch style.aligned {
                case .bottomToTop:
                    let imageVerticalOffset = (titleFrame.size.height) / 2
                    let titleVerticalOffset = (imageFrame.size.height) / 2
                    let imageHorizontalOffset = (titleFrame.size.width) / 2
                    let titleHorizontalOffset = (imageFrame.size.width) / 2
                    
                    titleEdgeInsets = UIEdgeInsets(
                        top: titleVerticalOffset + space,
                        left: -titleHorizontalOffset,
                        bottom: -(titleVerticalOffset + space),
                        right: titleHorizontalOffset)
                    imageEdgeInsets = UIEdgeInsets(
                        top: -(imageVerticalOffset + space),
                        left: imageHorizontalOffset,
                        bottom: (imageVerticalOffset + space),
                        right: -imageHorizontalOffset)
                case .leftToRight:
                    imageEdgeInsets = UIEdgeInsets(
                        top: 0,
                        left: (titleFrame.size.width + space),
                        bottom: 0,
                        right: -(titleFrame.size.width + space))
                    titleEdgeInsets = UIEdgeInsets(
                        top: 0,
                        left: -(imageFrame.size.width + space),
                        bottom: 0,
                        right: (imageFrame.size.width + space))
                case .rightToLeft:
                    imageEdgeInsets = UIEdgeInsets(
                        top: 0,
                        left: -space,
                        bottom: 0,
                        right: space)
                    titleEdgeInsets = UIEdgeInsets(
                        top: 0,
                        left: space,
                        bottom: 0,
                        right: -space)
                }
            }
        }
    }
}

// MARK: - buttonStyle model

enum ThanosButtonStyle {
    case fill // 顏色填滿
    case outline // 外框線
    case text // 純文字
    case icon // 純圖片
    case textIcon // 文字 + 圖片
}

enum Aligned {
    case rightToLeft
    case leftToRight
    case bottomToTop
}

// MARK: - protocol

protocol ThanosSettable {
    var buttonStyles: [ThanosButtonStyle] { get }
    
    // default style
    var scale: CGFloat { get set }
    var cornerRadius: CGFloat { get set }
    var borderWidth: CGFloat { get set }
    
    // fill style
    var fillNormalColor: UIColor { get set }
    var fillPressedColor: UIColor { get set }
    var fillDisableColor: UIColor? { get set }
    
    // outline style
    var outlineNormalColor: UIColor { get set }
    var outlinePressedColor: UIColor { get set }
    var outlineDisableColor: UIColor? { get set }
    
    // text style
    var textFont: UIFont { get set }
    var textNormalColor: UIColor { get set }
    var textPressedColor: UIColor { get set }
    var textDisableColor: UIColor? { get set }
    
    // icon style
    var iconNormal: UIImage? { get set }
    var iconPressed: UIImage? { get set }
    var iconDisable: UIImage? { get set }
    
    // aligned style
    var aligned: Aligned { get set }
    var space: CGFloat { get set }
}

// MARK: - protocol fill style

extension ThanosSettable {
    var fillNormalColor: UIColor {
        get { .clear } set { }
    }
    
    var fillPressedColor: UIColor {
        get { UIColor.clear.withAlphaComponent(0.6) } set { }
    }
    
    var fillDisableColor: UIColor? {
        get { nil } set { }
    }
}
    
// MARK: - protocol outline style

extension ThanosSettable {
    var borderWidth: CGFloat {
        get { 0.0 } set { }
    }
    var outlineNormalColor: UIColor {
        get { .black } set { }
    }
    
    var outlinePressedColor: UIColor {
        get { UIColor.black.withAlphaComponent(0.6) } set { }
    }
    
    var outlineDisableColor: UIColor? {
        get { nil } set { }
    }
}

// MARK: - protocol text style

extension ThanosSettable {
    var textFont: UIFont {
        get { UIFont.systemFont(ofSize: 16, weight: .medium) } set { }
    }
    
    var textNormalColor: UIColor {
        get { .black } set { }
    }
    
    var textPressedColor: UIColor {
        get { UIColor.black.withAlphaComponent(0.6) } set { }
    }
    
    var textDisableColor: UIColor? {
        get { nil } set { }
    }
}

//MARK: - protocol icon style

extension ThanosSettable {
    var iconNormal: UIImage? {
        get { nil } set { }
    }
    
    var iconPressed: UIImage? {
        get { nil } set { }
    }
    
    var iconDisable: UIImage? {
        get { nil } set { }
    }
}

//MARK: - protocol aligned style

extension ThanosSettable {
    var aligned: Aligned {
        get { .rightToLeft } set { }
    }
    
    var space: CGFloat {
        get { 0.0 } set { }
    }
}
