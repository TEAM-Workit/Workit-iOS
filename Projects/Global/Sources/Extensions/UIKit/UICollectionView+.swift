//
//  UICollectionView+.swift
//  Global
//
//  Created by 김혜수 on 2022/12/21.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit.UICollectionView

protocol NibLoadable: AnyObject {
    static var nibName: String { get }
}

protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension NibLoadable where Self: UIView {
    internal static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UICollectionView {
    public func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable Dequeue Reusable")
        }
        return cell
    }
    
    public func dequeueReusableView<T: UICollectionReusableView>(_: T.Type, indexPath: IndexPath, kind: String) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.className, for: indexPath as IndexPath) as? T else {
            fatalError("Unable Dequeue Reusable")
        }
        return view
    }
    
    public func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    public func registerReusableView<T: UICollectionReusableView>(_: T.Type, kind: String) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.className)
    }
}

extension UICollectionViewCell: NibLoadable { }
extension UICollectionViewCell: ReusableCell { }
