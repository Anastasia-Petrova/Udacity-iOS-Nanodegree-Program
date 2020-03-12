//
//  ViewController.swift
//  OnTheMap
//
//  Created by Anastasia Petrova on 12/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpLiginView()
    }

    func setUpLiginView() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 40
        
        
        let imageView = UIImageView(image: UIImage(named:  "logo-u"))
        imageView.contentMode = .scaleAspectFit
        
        let textfieldsStackView = UIStackView()
        textfieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        textfieldsStackView.axis = .vertical
        textfieldsStackView.distribution = .fillEqually
        textfieldsStackView.spacing = 6
        
        let emailTextField = UITextField()
        emailTextField.borderStyle = .roundedRect
        emailTextField.placeholder = "Email"
        emailTextField.isUserInteractionEnabled = true
        emailTextField.adjustsFontSizeToFitWidth = true

        let passwordTextField = UITextField()
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "Password"
        passwordTextField.isUserInteractionEnabled = true
        passwordTextField.adjustsFontSizeToFitWidth = true
        
        let loginButton = UIButton()
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.clear.cgColor
        loginButton.titleLabel?.font = .systemFont(ofSize: 12)
        loginButton.setTitle("LOG IN", for: .normal)
        
        let singUpStackView = UIStackView()
        singUpStackView.translatesAutoresizingMaskIntoConstraints = false
        singUpStackView.axis = .horizontal
        singUpStackView.distribution = .equalCentering
        singUpStackView.alignment = .center
        singUpStackView.spacing = 8
        
        let singUpLabel = UILabel()
        singUpLabel.font = .systemFont(ofSize: 12, weight: .light)
        singUpLabel.numberOfLines = 1
        singUpLabel.text = "Don't have an account?"
        singUpLabel.textColor = .black
        singUpLabel.textAlignment = .center
        
        let singUpButton = UIButton()
        singUpButton.backgroundColor = .clear
        singUpButton.setTitle("Sing Up", for: .normal)
        singUpButton.setTitleColor(.systemBlue, for: .normal)
        singUpButton.titleLabel?.font = .systemFont(ofSize: 12)
        
        singUpStackView.addArrangedSubview(UIView())
        singUpStackView.addArrangedSubview(singUpLabel)
        singUpStackView.addArrangedSubview(singUpButton)
        singUpStackView.addArrangedSubview(UIView())
        
        textfieldsStackView.addArrangedSubview(emailTextField)
        textfieldsStackView.addArrangedSubview(passwordTextField)
        textfieldsStackView.addArrangedSubview(loginButton)
        textfieldsStackView.addArrangedSubview(singUpStackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textfieldsStackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40)
        ])
    }
}

