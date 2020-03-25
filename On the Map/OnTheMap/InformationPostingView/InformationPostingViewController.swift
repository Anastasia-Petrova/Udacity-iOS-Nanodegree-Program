//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Anastasia Petrova on 22/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit
import MapKit

final class InformationPostingViewController: UIViewController {
    let locationTextField = UITextField()
    let linkTextField = UITextField()
    let mapView = MKMapView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Location"
        self.view.backgroundColor = .white
        setUpNavigationBar()
        setUpInfoView()
        setUpMapView()
    }
    
    private func setUpNavigationBar() {
        let cancelButton = UIBarButtonItem(
            title: "CANCEL",
            style: .plain,
            target: self,
            action: #selector(cancel)
        )
        cancelButton.setTitleTextAttributes(
            [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .semibold),
                NSAttributedString.Key.foregroundColor : UIColor.systemBlue
            ],
            for: .normal
        )
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func setUpInfoView() {
        let imageView = UIImageView(image: UIImage(named: "icon_world"))
        imageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.numberOfLines = 2
        label.text = "Where are you studding today?📚"
        label.textColor = .systemBlue
        label.textAlignment = .center
        
        locationTextField.borderStyle = .roundedRect
        locationTextField.placeholder = "Location"
        locationTextField.isUserInteractionEnabled = true
        locationTextField.adjustsFontSizeToFitWidth = true
        
        linkTextField.borderStyle = .roundedRect
        linkTextField.placeholder = "Link"
        linkTextField.isUserInteractionEnabled = true
        linkTextField.adjustsFontSizeToFitWidth = true
        
        let findLocationButton = UIButton()
        findLocationButton.backgroundColor = .systemBlue
        findLocationButton.layer.cornerRadius = 5
        findLocationButton.layer.borderWidth = 1
        findLocationButton.layer.borderColor = UIColor.clear.cgColor
        findLocationButton.titleLabel?.font = .systemFont(ofSize: 14)
        findLocationButton.setTitle("FIND LOCATION", for: .normal)
        findLocationButton.addTarget(self, action: #selector(findLocation), for: .touchUpInside)
        
        let textFieldsStackView = UIStackView(
            arrangedSubviews: [
                locationTextField,
                linkTextField,
                findLocationButton,
            ]
        )
        
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldsStackView.axis = .vertical
        textFieldsStackView.distribution = .fillEqually
        textFieldsStackView.spacing = 6
        
        let stackView = UIStackView(
            arrangedSubviews: [
                imageView,
                label,
                textFieldsStackView
            ]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 40
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
    
    private func setUpMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        mapView.isHidden = true
    }
    
    @objc func findLocation() {
        mapView.isHidden = false
        searchLocation()
    }
    
    func searchLocation() {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = locationTextField.text
        searchRequest.region = mapView.region
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard response == response else {
                print(error!)
                return
            }
            let mapItem = response?.mapItems.first
            if let placemark = mapItem?.placemark {
                self.makeMapAnnotations(placemark: placemark)
            }
        }
    }
    
    private func makeMapAnnotations(placemark: MKPlacemark) {
        let coordinate = placemark.coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = placemark.name
        mapView.addAnnotation(annotation)
        zoomPinAres(placemark)
    }
    
    private func zoomPinArea(_ placemark: MKPlacemark) {
        let span = MKCoordinateSpan(
            latitudeDelta: 0.5,
            longitudeDelta: 0.5
        )
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
