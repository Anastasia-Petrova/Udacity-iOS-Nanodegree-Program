//
//  SentMemesViewController.swift
//  Meme
//
//  Created by Anastasia Petrova on 21/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class SentMemesViewController: UIViewController {
    let tableView = UITableView()
    let dataSource = DataSource()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayout())
    let tabBar = UITabBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Sent Memes"
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = dataSource
        tableView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        setUpNavigationBar()
        setUpTableView()
        setUpCollectionView()
        setUpTabBar()
        tabBar.selectedItem = tabBar.items?.first
    }
    
    override func viewDidLayoutSubviews() {
        if let layout = collectionView.collectionViewLayout as? CollectionViewLayout {
            layout.setWidth(width: view.frame.width)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    private func setUpNavigationBar() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,  action: #selector(presentEditorViewController))
        navigationItem.rightBarButtonItem = addItem
    }
    
    private func setUpTabBar() {
        tabBar.delegate = self
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func setUpCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        collectionView.backgroundColor = .white
        collectionView.isHidden = true
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 1.0
        longPress.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(longPress)
    }
    
    @objc func presentEditorViewController() {
        let vc = MemeEditorViewController { [weak self] in
            self?.dataSource.reloadData()
            self?.tableView.reloadData()
            self?.collectionView.reloadData()
        }
        self.navigationController?.present(vc, animated: true)
    }
    
    @objc func handleLongPress(_ longPress: UILongPressGestureRecognizer) {
//        if longPress.state != .ended {
//            return
//        }
        //TODO: set done button in viewDidLoad and immediately make if isHidden = true
        //and then just set isHidden true/false when needed instead of re-creating button
        //like it is done now
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self,  action: #selector(doneAction))
        
        navigationItem.leftBarButtonItem = doneItem
        navigationItem.rightBarButtonItem?.isEnabled = false
        //TODO: do not dig into optional items of tabBar. Assign whatever tab bar item we need
        //to access as property and use it directly
        tabBar.items?.first?.isEnabled = false
        dataSource.isEditModeOn = true
        collectionView.reloadData()
        //TODO: Make sure this is really needed
        self.view.layoutIfNeeded()
    }
    
    @objc func doneAction() {
        //TODO: just set doneItem property isHidden true
        navigationItem.leftBarButtonItem = nil
        //TODO: use property
        navigationItem.rightBarButtonItem?.isEnabled = true
        //TODO: use property
        tabBar.items?.first?.isEnabled = true
        dataSource.isEditModeOn = false
        collectionView.reloadData()
    }

}

extension SentMemesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = dataSource.tableView(tableView, cellForRowAt: indexPath) as? TableViewCell
        if let image = cell?.memeImageView.image {
            let vc = DetailViewController(image: image)
            self.navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}

extension SentMemesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = dataSource.collectionView(collectionView, cellForItemAt: indexPath) as? CollectionViewCell
        if let image = cell?.memeImageView.image {
            let vc = DetailViewController(image: image)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SentMemesViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let selectedIndex = tabBar.items?.firstIndex(of: item) else { return }
        if selectedIndex == 0 {
            collectionView.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        } else {
            tableView.isHidden = true
            collectionView.isHidden = false
            collectionView.reloadData()
        }
    }
}

