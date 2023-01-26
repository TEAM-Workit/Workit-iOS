//
//  UITableView+.swift
//  Global
//
//  Created by madilyn on 2023/01/26.
//  Copyright © 2023 com.workit. All rights reserved.
//

import UIKit.UITableView

public extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(
        withType cellType: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.className, for: indexPath) as? T else {
            fatalError("Could not find cell with reuseID \(T.className)")
        }
        return cell
    }
    
    func register<T>(
        cell: T.Type,
        forCellReuseIdentifier reuseIdentifier: String = T.className
    ) where T: UITableViewCell {
        register(cell, forCellReuseIdentifier: reuseIdentifier)
    }
}
