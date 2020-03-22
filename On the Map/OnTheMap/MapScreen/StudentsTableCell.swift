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
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            pinImageView.widthAnchor.constraint(equalToConstant: 60),
            pinImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 4
        
        studentStackView.alignment = .fill
        studentStackView.distribution = .fill
        studentStackView.axis = .vertical
        studentStackView.spacing = 6
        
        pinImageView.contentMode = .scaleAspectFit
        pinImageView.clipsToBounds = true
        studentName.font = UIFont.systemFont(ofSize: 15)
        studentName.numberOfLines = 1
        studentLink.font = UIFont.systemFont(ofSize: 15)
        studentLink.textColor = .lightGray
        studentLink.numberOfLines = 1
    }
}
