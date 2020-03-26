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
    let dataSource: StudentsTableDataSource
    let tabBar = UITabBar()
    let mapBarItem = UITabBarItem()
    let tableBarItem = UITabBarItem()
    var locations: [StudentLocation]
    var annotations = [MKPointAnnotation]()
    
    init(locations: [StudentLocation]) {
        self.locations = locations
        self.dataSource = StudentsTableDataSource(studentsLocations: locations)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        setUpNavigationBar()
        setUpTabBar()
        setUpTableView()
        tabBar.selectedItem = mapBarItem
        mapView.delegate = self
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
        makeMapAnnotations(locations: locations)
    }
    
    private func makeMapAnnotations(locations: [StudentLocation]) {
        for location in locations {
            let coordinate = CLLocationCoordinate2D(
                latitude: Double(location.latitude),
                longitude: Double(location.longitude)
            )
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = location.firstName + " " + location.lastName
            annotation.subtitle = location.link
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    private func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        tableView.isHidden = true
    }
    
    private func setUpNavigationBar() {
        let addItem = UIBarButtonItem(
            image: UIImage(named: "icon_pin"),
            style: .plain,
            target: self,
            action: #selector(presentInfoViewController)
        )
        
        let refreshItem = UIBarButtonItem(
            image: UIImage(named: "icon_refresh"),
            style: .plain,
            target: self,
            action: #selector(handleRefreshAction)
        )
        
        navigationItem.leftBarButtonItem = addItem
        navigationItem.rightBarButtonItem = refreshItem
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
        mapBarItem.image = UIImage(named: "mapview")
        mapBarItem.landscapeImagePhone = UIImage(named: "mapview")
        tableBarItem.image = UIImage(named: "listview")
        tableBarItem.landscapeImagePhone = UIImage(named: "listview")
        tabBar.setItems([mapBarItem, tableBarItem], animated: false)
    }
    
    @objc func presentInfoViewController() {
        let vc = InformationPostingViewController()
        let nvc = UINavigationController(rootViewController: vc)
        self.present(nvc, animated: true)
    }
    
    private func open(url: URL) {
        let app = UIApplication.shared
        app.open(url, options: [:], completionHandler: nil)
    }
    
    private func refreshLocationsIfNeeded(_ newLocations: [StudentLocation]) {
        guard locations != newLocations else {
            print("Zero New Locations Were Added!!")
            return
        }
        
        locations = newLocations
        dataSource.studentsLocations = newLocations
        tableView.reloadData()
        mapView.removeAnnotations(self.annotations)
        makeMapAnnotations(locations: self.locations)
    }
    
    @objc func handleRefreshAction() {
        UdacityClient.getStudentsLocations(completionQueue: .main) { result in
            switch result {
            case .success(let responseObject):
                self.refreshLocationsIfNeeded(responseObject.locations)
            case.failure(let error):
                print(error)
            }
        }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = dataSource.tableView(tableView, cellForRowAt: indexPath) as? StudentsTableCell
        if let link = cell?.studentLink.text, let url = URL(string: link) {
            open(url: url)
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        if let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView  {
            pinView.annotation = annotation
            return pinView
        } else {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView.canShowCallout = true
            pinView.pinTintColor = .red
            pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return pinView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard control == view.rightCalloutAccessoryView,
            let subtitle = view.annotation?.subtitle,
            let link = subtitle,
            let url = URL(string: link) else {
            return
        }
        open(url: url)
    }
}
