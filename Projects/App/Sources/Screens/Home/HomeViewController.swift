//
//  HomeViewController.swift
//  App
//
//  Created by 김혜수 on 2022/11/07.
//  Copyright © 2022 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

final class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        setUI()
    }

    private func setUI() {
        view.backgroundColor = .wkMainPurple
    }

    private func setNavigationBar() {
        self.navigationController?.setNavigationBarApperance(backgroundColor: .clear, tintColor: .wkWhite)
        let button = WKNavigationButton(image: Image.wkMenu)
        let barbuttonitem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barbuttonitem
    }

}
