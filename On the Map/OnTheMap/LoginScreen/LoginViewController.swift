//
//  ViewController.swift
//  OnTheMap
//
//  Created by Anastasia Petrova on 12/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let didLogingCallback: () -> Void
    
    init(callback: @escaping () -> Void) {
        didLogingCallback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpLiginView()
    }

    func setUpLiginView() {
        let imageView = UIImageView(image: UIImage(named:  "logo-u"))
        imageView.contentMode = .scaleAspectFit
        
        emailTextField.borderStyle = .roundedRect
        emailTextField.placeholder = "Email"
        emailTextField.isUserInteractionEnabled = true
        emailTextField.adjustsFontSizeToFitWidth = true
        emailTextField.text = "agency.cupid@gmail.com"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "Password"
        passwordTextField.isUserInteractionEnabled = true
        passwordTextField.adjustsFontSizeToFitWidth = true
        passwordTextField.text = "qazwsxedc123123"
        
        let loginButton = UIButton()
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.clear.cgColor
        loginButton.titleLabel?.font = .systemFont(ofSize: 14)
        loginButton.setTitle("LOG IN", for: .normal)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        let singUpLabel = UILabel()
        singUpLabel.font = .systemFont(ofSize: 14, weight: .light)
        singUpLabel.numberOfLines = 1
        singUpLabel.text = "Don't have an account?"
        singUpLabel.textColor = .black
        singUpLabel.textAlignment = .center
        
        let singUpButton = UIButton()
        singUpButton.backgroundColor = .clear
        singUpButton.setTitle("Sing Up", for: .normal)
        singUpButton.setTitleColor(.systemBlue, for: .normal)
        singUpButton.titleLabel?.font = .systemFont(ofSize: 14)
        
        let singUpStackView = UIStackView(
            arrangedSubviews: [
                UIView(),
                singUpLabel,
                singUpButton,
                UIView()
            ]
        )
        singUpStackView.translatesAutoresizingMaskIntoConstraints = false
        singUpStackView.axis = .horizontal
        singUpStackView.distribution = .equalCentering
        singUpStackView.alignment = .center
        singUpStackView.spacing = 8
        
        let textFieldsStackView = UIStackView(
            arrangedSubviews: [
                emailTextField,
                passwordTextField,
                loginButton,
                singUpStackView
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
            imageView.heightAnchor.constraint(equalToConstant: 70),
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50)
        ])
    }
    
    @objc func handleLogin() {
        UdacityClient.requestSessionID(username: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        print("username: \(emailTextField.text ?? ""), password: \(passwordTextField.text ?? "")")
        didLogingCallback()
    }
}

