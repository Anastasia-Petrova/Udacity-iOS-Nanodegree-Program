//
//  TravelMapViewController.swift
//  VirtualTourist
//
//  Created by Anastasia Petrova on 03/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit
import MapKit

class TravelMapViewController : UIViewController {
    let mapView = MKMapView(frame: .zero)
    
    lazy var longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapView()
        setUpLongPressGestureRecognizer()
    }
    
    private func setUpMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setUpLongPressGestureRecognizer() {
        longPressRecognizer.minimumPressDuration = 1.0
        longPressRecognizer.delaysTouchesBegan = true
        mapView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func handleLongPressGesture() {
        
    }
}

