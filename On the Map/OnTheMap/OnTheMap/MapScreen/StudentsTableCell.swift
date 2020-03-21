//
//  StudentsTableCellTableViewCell.swift
//  OnTheMap
//
//  Created by Anastasia Petrova on 20/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class StudentsTableCell: UITableViewCell {
    static let identifier = "StudentsTableCell"
    
    let pinImageView = UIImageView(image: UIImage(named: "icon_pin"))
    let studentName = UILabel()
    let studentLink = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubviews() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let studentStackView = UIStackView()
        studentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(pinImageView)
        stackView.addArrangedSubview(studentStackView)
        studentStackView.addArrangedSubview(studentName)
        studentStackView.addArrangedSubview(studentLink)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            pinImageView.heightAnchor.constraint(equalToConstant: 140)
        ])
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        studentStackView.alignment = .center
        studentStackView.distribution = .fillEqually
        studentStackView.axis = .vertical
        studentStackView.spacing = 16
        
        pinImageView.contentMode = .scaleAspectFill
        pinImageView.clipsToBounds = true
        studentName.font = UIFont.systemFont(ofSize: 12)
        studentName.numberOfLines = 1
        studentLink.font = UIFont.systemFont(ofSize: 12)
        studentLink.numberOfLines = 1
    }
}
