//
//  WKTabbar.swift
//  DesignSystem
//
//  Created by 윤예지 on 2022/12/12.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit

protocol WKTabbarDelegate: AnyObject {
    func wkTabbar(_ tabbar: WKTabbar, _ didSelectedItemAt: Int)
}

final class WKTabbar: UITabBar {
    
    @objc public var centerButtonActionHandler: () -> () = {}
    
    // MARK: - UIComponents
    
    private lazy var stackView: UIStackView = {
        let stackview = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 44.0
        return stackview
    }()
    
    private var shapeLayer: CALayer?
    
    // MARK: - Properties
    
    weak var tabbarController: UITabBarController?
    
    // MARK: - Actions
    
    @objc
    func centerButtonAction(sender: UIButton) {
        self.centerButtonActionHandler()
    }
    
    @objc
    func itemDidTapped(_ sender: UITapGestureRecognizer) {
        if let item = sender.view as? WKTabbarItem,
           let index = self.stackView.arrangedSubviews.firstIndex(of: item) {
            self.changeAppearence(selectedIndex: index)
        }
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        self.setLayout()
        self.addShape()
        self.setCenterButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - override Methods
    
    override func draw(_ rect: CGRect) {
        self.addShape()
        self.setCenterButton()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
    
    // MARK: - Methods
    
    private func setCenterButton() {
        let centerButton = UIButton(frame: CGRect(x: (self.bounds.width / 2) - (Number.buttonHeight / 2), y: -24, width: Number.buttonHeight, height: Number.buttonHeight))
        centerButton.layer.cornerRadius = centerButton.frame.size.width / 2.0
        centerButton.setImage(Image.wkWrite, for: .normal)
        centerButton.backgroundColor = .wkMainNavy
        centerButton.tintColor = UIColor.white
        centerButton.addTarget(self, action: #selector(self.centerButtonAction), for: .touchUpInside)
        
        self.addSubview(centerButton)
    }
    
    public func setItems(_ items: [WKTabbarItem]) {
//        items.forEach { item in
//            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(itemDidTapped(_:)))
//            item.addGestureRecognizer(tapGestureRecognizer)
//            self.stackView.addArrangedSubview(item)
//        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(itemDidTapped(_:)))
        items[0].addGestureRecognizer(tapGestureRecognizer)
        self.stackView.addArrangedSubview(items[0])
    }
    
    private func changeAppearence(selectedIndex: Int) {
        for (index, item) in self.stackView.arrangedSubviews.enumerated() {
            if let item = item as? WKTabbarItem {
                item.isSelected = index == selectedIndex
            }
        }
    }
    
    private func setLayout() {
        self.addSubview(stackView)
        
        let stackWidth: CGFloat = 375 - 156 + 28
        self.stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(6)
            $0.width.equalTo(stackWidth / 375 * UIScreen.main.bounds.width)
            $0.height.equalTo(58)
        }
    }
    
}

extension WKTabbar {
    enum Number {
        static let padding: CGFloat = 8.0
        static let buttonHeight: CGFloat = 64
        static let circleRadius: CGFloat = 20
        static let height: CGFloat = 80
    }
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.wkBlack8.cgColor
        shapeLayer.fillColor = UIColor.wkWhite.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowColor = UIColor.gray.cgColor
        shapeLayer.shadowOpacity = 0.18
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    func createPath() -> CGPath {
        let path = UIBezierPath()
        
        let f = CGFloat(Number.buttonHeight / 2.0) + Number.padding
        let radius = Number.circleRadius
        
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: frame.width / 2.0  - f - (radius / 2.0), y: 0))
        path.addQuadCurve(to: CGPoint(x: frame.width / 2.0  - f, y: (radius / 2.0)),
                          controlPoint: CGPoint(x: frame.width / 2.0  - f, y: 0))
        path.addArc(withCenter: CGPoint(x: frame.width / 2.0 , y: (radius / 2.0)),
                    radius: f, startAngle: .pi, endAngle: 0, clockwise: false)
        path.addQuadCurve(to: CGPoint(x: frame.width / 2.0 + f + (radius / 2.0), y: 0),
                          controlPoint: CGPoint(x: frame.width / 2.0  + f, y: 0))
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        path.addLine(to: CGPoint(x: frame.width, y: Number.height))
        path.addLine(to: CGPoint(x: 0.0, y: Number.height))
        path.close()
        
        return path.cgPath
    }
}
