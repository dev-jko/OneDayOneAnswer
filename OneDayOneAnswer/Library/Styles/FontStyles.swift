//
//  FontStyles.swift
//  OneDayOneAnswer
//
//  Created by Jaedoo Ko on 2020/07/13.
//  Copyright © 2020 JMJ. All rights reserved.
//

import UIKit

public func fontStyle(_ fontName: String) -> (CGFloat) -> UIFont? {
    return { fontSize in
        return UIFont(name: fontName, size: fontSize)
    }
}

public func defaultFontStyle(fontSize: CGFloat) -> UIFont? {
    return fontStyle("DXPnMStd-Regular")(fontSize)
}
