//
//  ListLayout.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/23.
//  Copyright © 2023 com.workit. All rights reserved.
//

import UIKit

struct ListLayout {
    static func create(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        config.backgroundColor = .wkWhite
        let section = NSCollectionLayoutSection.list(
            using: config,
            layoutEnvironment: layoutEnvironment)
        section.interGroupSpacing = 12
        section.contentInsets = .init(top: 0, leading: 20, bottom: 104, trailing: 20)
        return section
    }
}
