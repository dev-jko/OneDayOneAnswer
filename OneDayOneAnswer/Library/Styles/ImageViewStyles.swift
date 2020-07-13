//
//  ImageViewStyles.swift
//  OneDayOneAnswer
//
//  Created by Jaedoo Ko on 2020/07/12.
//  Copyright © 2020 JMJ. All rights reserved.
//

import UIKit

private func baseImageViewStyle(imageView: UIImageView) -> UIImageView {
    imageView.backgroundColor = .white
    return imageView
}

public func backgroundImageViewStyle(image: UIImage) -> (UIImageView) -> UIImageView {
    return baseImageViewStyle
        <> { $0.image = image; return $0 }
}

public func defaultBackgroundImageViewStyle() -> (UIImageView) -> UIImageView {
    let image = #imageLiteral(resourceName: "catcat0")
    return backgroundImageViewStyle(image: image)
}
