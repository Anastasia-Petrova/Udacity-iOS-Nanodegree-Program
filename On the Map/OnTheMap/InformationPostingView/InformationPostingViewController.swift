//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Anastasia Petrova on 22/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class InformationPostingViewController: UIViewController {
    let locationTextField = UITextField()
    let linkTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Location"
        self.view.backgroundColor = .white
        setUpNavigationBar()
        setUpInfoView()
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
        findLocationButton.titleLabel?.font = .systemFont(ofSize: 13)
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
                textFieldsStackView
            ]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 60
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50)
        ])
    }
    
    @objc func findLocation() {
        
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
