//
//  TabBarItem.swift
//  Meme
//
//  Created by Anastasia Petrova on 17/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class TabBar: UITabBar {
    
    init(items: String...) {
        super.init(frame: .zero)
        self.setItems(items.map(TabBarItem.init), animated: false)
        self.tintColor = .white
        self.itemPositioning = .centered
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

