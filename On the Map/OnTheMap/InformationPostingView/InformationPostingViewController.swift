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
    let findLocationButton = UIButton()
    let mapView = MKMapView(frame: .zero)
    let submitButton = UIButton()
    let activityIndicator = UIActivityIndicatorView()
    let accountKey: String
    var studentLocationInfo: MKPlacemark?
    let didPostLocationCallback: () -> Void
    
    init(accountKey: String, callback: @escaping () -> Void) {
        self.accountKey = accountKey
        didPostLocationCallback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Location"
        view.backgroundColor = .white
        setUpNavigationBar()
        setUpInfoView()
        setUpMapView()
        setUpSubmitButton()
        mapView.delegate = self
        locationTextField.delegate = self
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
        
        findLocationButton.backgroundColor = .systemBlue
        findLocationButton.layer.cornerRadius = 5
        findLocationButton.layer.borderWidth = 1
        findLocationButton.layer.borderColor = UIColor.clear.cgColor
        findLocationButton.titleLabel?.font = .systemFont(ofSize: 14)
        findLocationButton.setTitle("FIND LOCATION", for: .normal)
        findLocationButton.addTarget(self, action: #selector(findLocation), for: .touchUpInside)
        
        activityIndicator.color = .systemBlue
        activityIndicator.hidesWhenStopped = false
        activityIndicator.alpha = 0
        
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
                textFieldsStackView,
                activityIndicator
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
        setFindLocationButtonEnabled(false)
    }
    
    private func setFindLocationButtonEnabled(_ isEnabled: Bool) {
        findLocationButton.isEnabled = isEnabled
        findLocationButton.backgroundColor = isEnabled ? .systemBlue : .systemGray
    }
    
    private func setUpMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        mapView.isHidden = true
    }
    
    private func setUpSubmitButton() {
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(submitButton)
        submitButton.backgroundColor = .systemBlue
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.clear.cgColor
        submitButton.titleLabel?.font = .systemFont(ofSize: 18)
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
        
        submitButton.isHidden = true
    }
    
    private func presentMapView() {
        mapView.isHidden = false
        submitButton.isHidden = false
    }
    
    private func searchLocation() {
        setActivityIndicatorOn(true)
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = locationTextField.text
        searchRequest.region = mapView.region
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            self.setActivityIndicatorOn(false)
            guard let response = response else {
                self.presentAlert(title: "Location Not Found!", message: "Looks like your location was not found. Try another one.")
                return
            }
            let mapItem = response.mapItems.first
            if let placemark = mapItem?.placemark {
                self.studentLocationInfo = placemark
                self.makeMapAnnotations(placemark: placemark)
                self.presentMapView()
            }
        }
    }
    
    private func makeMapAnnotations(placemark: MKPlacemark) {
        let coordinate = placemark.coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = placemark.name
        if let region = placemark.administrativeArea,
            let country = placemark.country {
            annotation.subtitle = region + ", " + country
        }
        mapView.addAnnotation(annotation)
        zoomPinArea(placemark)
    }
    
    private func zoomPinArea(_ placemark: MKPlacemark) {
        let span = MKCoordinateSpan(
            latitudeDelta: 0.5,
            longitudeDelta: 0.5
        )
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil
            )
        )
        present(alert, animated: true, completion: nil)
    }
    
    private func setActivityIndicatorOn(_ isOn: Bool) {
        activityIndicator.alpha = isOn ? 1 : 0
        if isOn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    @objc func findLocation() {
        searchLocation()
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    private func postLocation(firstName: String, lastName: String, name: String, link: String, location: MKPlacemark) {
        UdacityClient.postUserLocation(
            firstName: firstName,
            lastName: lastName,
            location: name,
            link: link,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        ) { error in
            switch error {
            case .some:
                self.presentAlert(title: "Error", message: "Your location was not submitted")
            case .none:
                self.didPostLocationCallback()
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func submit() {
        guard let location = studentLocationInfo,
            let name = location.name else {
                return
        }
        var firstName = ""
        var lastName = ""
        
        UdacityClient.getUserInfo(accountKey: accountKey) { result in
            switch result {
            case .success(let responseObject):
                firstName = responseObject.firstName
                lastName = responseObject.lastName
                DispatchQueue.main.async {
                    let link = self.linkTextField.text ?? ""
                    self.postLocation(
                        firstName: firstName,
                        lastName: lastName,
                        name: name,
                        link: link,
                        location: location
                    )
                }
            case .failure(let error):
                let text: String?
                switch error {
                case let e as LocalizedError:
                    text = e.errorDescription
                case let e:
                    text = e.localizedDescription
                }
                DispatchQueue.main.async {
                    UIView.animate(
                        withDuration: 0.2,
                        animations: {
                            self.presentAlert(title: text ?? "Error!", message: "")
                    })
                }
            }
        }
    }
}

extension InformationPostingViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        if let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView  {
            pinView.annotation = annotation
            return pinView
        } else {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView.canShowCallout = true
            pinView.pinTintColor = .red
            return pinView
        }
    }
}

extension InformationPostingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let replacementRange = Range(range, in: currentText) else {
            return false
        }
        let updatedText = currentText.replacingCharacters(in: replacementRange, with: string)
        setFindLocationButtonEnabled(!updatedText.isEmpty)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
        return true
    }
}
