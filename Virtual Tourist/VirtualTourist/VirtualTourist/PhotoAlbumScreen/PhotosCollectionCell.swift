//
//  PhotosCollectionCell.swift
//  VirtualTourist
//
//  Created by Anastasia Petrova on 04/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class PhotosCollectionCell: UICollectionViewCell {
    static let identifier = "PhotosCollectionCell"
    
    let photoImageView = UIImageView()
    
    override init(frame: CGRect) {
    super.init(frame: frame)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        photoImageView.image = UIImage(named: "udacity")?.withRenderingMode(.alwaysTemplate)
        photoImageView.tintColor = .lightGray
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
