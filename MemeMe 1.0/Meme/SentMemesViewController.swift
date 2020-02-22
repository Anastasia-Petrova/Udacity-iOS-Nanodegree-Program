//
//  SentMemesViewController.swift
//  Meme
//
//  Created by Anastasia Petrova on 21/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class SentMemesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Sent Memes"
        setUpNavigationBar()
        setUpTableView()
        setUpTabBar()
    }
    
    private func setUpNavigationBar() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,  action: #selector(pushEditorViewController))
        navigationItem.rightBarButtonItem = addItem
    }
    
    private func setUpTabBar() {
        let tabBar = UITabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tabBar)
        let gridBarItem = UITabBarItem()
        let collectionBarItem = UITabBarItem()
        NSLayoutConstraint.activate([
            tabBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        gridBarItem.image = UIImage(systemName: "rectangle.split.3x3")
        collectionBarItem.image = UIImage(systemName: "list.dash")
        tabBar.setItems([collectionBarItem, gridBarItem], animated: false)
    }
    
    private func setUpTableView() {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    @objc func pushEditorViewController() {
        let vc = MemeEditorViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
