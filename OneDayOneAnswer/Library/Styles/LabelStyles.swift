//
//  LabelStyles.swift
//  OneDayOneAnswer
//
//  Created by Jaedoo Ko on 2020/07/12.
//  Copyright © 2020 JMJ. All rights reserved.
//

import UIKit

private func baseLabelStyle(label: UILabel) -> UILabel {
    label.textColor = .white
    label.numberOfLines = 0
    label.textAlignment = .justified
    label.lineBreakMode = .byWordWrapping
    return label
}

public func defaultLabelStyle(fontSize: CGFloat) -> (UILabel) -> UILabel {
    let font = defaultFontStyle(fontSize: fontSize)
    return baseLabelStyle
        <> { $0.font = font; return $0 }
}
