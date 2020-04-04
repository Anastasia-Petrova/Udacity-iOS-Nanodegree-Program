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
        mapView.delegate = self
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
        let location = longPressRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
}

extension TravelMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        if let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView  {
            pinView.annotation = annotation
            return pinView
        } else {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView.pinTintColor = .red
            return pinView
        }
    }
}