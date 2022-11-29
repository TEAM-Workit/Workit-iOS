//
//  UIImage+.swift
//  Global
//
//  Created by 윤예지 on 2022/11/29.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit.UIImage

extension UIImage {
    public func resize(to size: CGSize, point: CGPoint = .zero) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: point, size: size))
        }
    }
}
