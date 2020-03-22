//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Anastasia Petrova on 20/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    let mapView = MKMapView(frame: .zero)
    let tableView = UITableView()
    let dataSource = StudentsTableDataSource() 
    let tabBar = UITabBar()
    let mapBarItem = UITabBarItem()
    let tableBarItem = UITabBarItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "On the Map"
        
        tableView.register(
            StudentsTableCell.self,
            forCellReuseIdentifier: StudentsTableCell.identifier
        )
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        setUpMapView()
        setUpTableView()
        setUpNavigationBar()
        setUpTabBar()
        tabBar.selectedItem = mapBarItem
    }
    
    private func setUpMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
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
        tableView.isHidden = true
    }
    
    private func setUpNavigationBar() {
        let addItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(presentInfoViewController)
        )
        let refreshItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(handleRefreshAction)
        )
        
        let logoutButton = UIBarButtonItem(
            title: "LOGOUT",
            style: .plain,
            target: self,
            action: #selector(handleLogout)
        )
        logoutButton.setTitleTextAttributes(
            [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .semibold),
                NSAttributedString.Key.foregroundColor : UIColor.systemBlue
            ],
            for: .normal
        )
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItems = [addItem, refreshItem]
    }
    
    private func setUpTabBar() {
        tabBar.delegate = self
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tabBar)
        NSLayoutConstraint.activate([
            tabBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        mapBarItem.image = UIImage(systemName: "map")
        tableBarItem.image = UIImage(systemName: "list.bullet")
        tabBar.setItems([mapBarItem, tableBarItem], animated: false)
    }
    
    @objc func presentInfoViewController() {
        let vc = InformationPostingViewController()
        let nvc = UINavigationController(rootViewController: vc)
        self.present(nvc, animated: true)
    }
    
    @objc func handleRefreshAction() {
        
    }
    
    @objc func handleLogout() {
        
    }
}

extension MapViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let selectedIndex = tabBar.items?.firstIndex(of: item) else { return }
        if selectedIndex == 0 {
            tableView.isHidden = true
            mapView.isHidden = false
        } else {
            mapView.isHidden = true
            tableView.isHidden = false
        }
    }
}

extension MapViewController: UITableViewDelegate {
    
}
