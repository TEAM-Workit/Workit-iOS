//
//  UIScrollView+.swift
//  DesignSystem
//
//  Created by madilyn on 2022/11/24.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit

extension UIScrollView {
    var scrollIndicators: (horizontal: UIView?, vertical: UIView?) {
        
        guard self.subviews.count >= 2 else {
            return (horizontal: nil, vertical: nil)
        }
        
        func viewCanBeScrollIndicator(view: UIView) -> Bool {
            let viewClassName = NSStringFromClass(type(of: view))
            return viewClassName == "_UIScrollViewScrollIndicator" || viewClassName == "UIImageView"
        }
        
        let horizontalScrollViewIndicatorIndex = self.subviews.count - 2
        let verticalScrollViewIndicatorIndex = self.subviews.count - 1
        
        var horizontalScrollIndicator: UIView?
        var verticalScrollIndicator: UIView?
        
        let viewForHorizontalScrollViewIndicator = self.subviews[horizontalScrollViewIndicatorIndex]
        if viewCanBeScrollIndicator(view: viewForHorizontalScrollViewIndicator) {
            horizontalScrollIndicator = viewForHorizontalScrollViewIndicator.subviews[0]
        }
        
        let viewForVerticalScrollViewIndicator = self.subviews[verticalScrollViewIndicatorIndex]
        if viewCanBeScrollIndicator(view: viewForVerticalScrollViewIndicator) {
            verticalScrollIndicator = viewForVerticalScrollViewIndicator.subviews[0]
        }
        
        return (horizontal: horizontalScrollIndicator, vertical: verticalScrollIndicator)
    }
}
