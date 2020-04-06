//
//  TravelMapViewController.swift
//  VirtualTourist
//
//  Created by Anastasia Petrova on 03/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit
import MapKit

final class TravelMapViewController : UIViewController {
    let mapView = MKMapView(frame: .zero)
    var coordinate = CLLocationCoordinate2D()
    var photos: [FlickrPhoto] = []
    
    lazy var longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapView()
        setUpLongPressGestureRecognizer()
        mapView.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationController?.isNavigationBarHidden = true
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
        coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        FlickrClient.getPhotos(latitude: "\(coordinate.latitude)", longitude: "\(coordinate.longitude)", page: 1) { result in
            switch result {
            case .success(let photos):
                self.photos = photos.searchResults
            case .failure:
                print("EEEERRRROOOOOOORRRRR!!!!!!")
            }
        }
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        navigationController?.pushViewController(PhotoAlbumViewController(coordinate: coordinate, photos: photos), animated: true)
    }
}
