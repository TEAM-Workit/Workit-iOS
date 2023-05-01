//
//  UITableView+.swift
//  Global
//
//  Created by madilyn on 2023/01/26.
//  Created by yjiyuni-MN on 2023/01/24.
//  Copyright © 2023 com.workit. All rights reserved.
//

import UIKit.UITableView

extension UITableView {
    
    public func dequeueReusableCell<T: UITableViewCell>(
        withType cellType: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.className, for: indexPath) as? T else {
            fatalError("Could not find cell with reuseID \(T.className)")
        }
        return cell
    }
    
    public func register<T>(
        cell: T.Type,
        forCellReuseIdentifier reuseIdentifier: String = T.className
    ) where T: UITableViewCell {
        register(cell, forCellReuseIdentifier: reuseIdentifier)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        
        return cell
    }
    
    public func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
}

extension UITableViewCell: ReusableView { }
