//
//  BackgroundView.swift
//  MemeMe
//
//  Created by Anastasia Petrova on 09/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setUpBackgroundView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpBackgroundView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.axis = .vertical
        
        let imageView = UIImageView(image: UIImage(systemName: "photo.on.rectangle"))
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.numberOfLines = 0
        label.text = Labels.EditorScreen.instructionText
        label.textColor = .lightGray
        label.textAlignment = .center
        label.text = "You haven't sent any memes yet"
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
