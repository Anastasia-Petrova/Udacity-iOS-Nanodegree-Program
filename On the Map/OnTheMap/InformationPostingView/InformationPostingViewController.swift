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
    
    @objc func findLocation() {
        
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
