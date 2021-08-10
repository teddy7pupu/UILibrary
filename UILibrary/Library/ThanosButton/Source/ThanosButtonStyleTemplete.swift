//
//  ThanosButtonStyleTemplete.swift
//  iOS-UILib
//
//  Created by Teddy on 2020/3/5.
//  Copyright © 2020 GOONS. All rights reserved.
//

import UIKit

struct FillStyle: ThanosSettable {
    // default style
    var buttonStyles: [ThanosButtonStyle] = [.fill]
    var scale: CGFloat = 1.0
    var cornerRadius: CGFloat = 0.0
    
    // fill style
    var fillNormalColor: UIColor = .clear
    var fillPressedColor: UIColor = UIColor.clear.withAlphaComponent(0.6)
    var fillDisableColor: UIColor? = nil
}

struct OutlineStyle: ThanosSettable {
    // default style
    var buttonStyles: [ThanosButtonStyle] = [.outline, .text]
    var scale: CGFloat = 1.0
    var cornerRadius: CGFloat = 0.0
    
    // outline style
    var borderWidth: CGFloat = 1
    var outlineNormalColor: UIColor = .black
    var outlinePressedColor: UIColor = UIColor.black.withAlphaComponent(0.6)
    var outlineDisableColor: UIColor? = nil
    
    // text style
    var textFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    var textNormalColor: UIColor = .black
    var textPressedColor: UIColor = UIColor.black.withAlphaComponent(0.6)
    var textDisableColor: UIColor? = nil
}

struct MixStyle: ThanosSettable {
    // default style
    var buttonStyles: [ThanosButtonStyle] = [.textIcon, .outline]
    var scale: CGFloat = 1.0
    var cornerRadius: CGFloat = 0.0
        
    // outline style
    var borderWidth: CGFloat = 1
    var outlineNormalColor: UIColor = .black
    var outlinePressedColor: UIColor = UIColor.black.withAlphaComponent(0.6)
    var outlineDisableColor: UIColor? = nil
    
    // text style
    var textFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    var textNormalColor: UIColor = .black
    var textPressedColor: UIColor = UIColor.black.withAlphaComponent(0.6)
    var textDisableColor: UIColor? = nil
    
    // icon style
    var iconNormal: UIImage? = nil
    var iconPressed: UIImage? = nil
    var iconDisable: UIImage? = nil
    
    // aligned style
    var aligned: Aligned = .rightToLeft
    var space: CGFloat = 0.0
}
