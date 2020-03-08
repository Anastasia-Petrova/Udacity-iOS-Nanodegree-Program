//
//  CollectionViewCell.swift
//  Meme
//
//  Created by Anastasia Petrova on 24/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    static let identifier = "CollectionViewCell"
    
    let memeImageView = UIImageView()
    let deleteImageView = UIImageView()
    
    override init(frame: CGRect) {
    super.init(frame: frame)
        memeImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(memeImageView)
        NSLayoutConstraint.activate([
            memeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            memeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            memeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            memeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        memeImageView.contentMode = .scaleAspectFill
        memeImageView.clipsToBounds = true
        setUpDeleteImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpDeleteImageView() {
        deleteImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(deleteImageView)
        NSLayoutConstraint.activate([
            deleteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            deleteImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            deleteImageView.widthAnchor.constraint(equalToConstant: 40),
            deleteImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        deleteImageView.contentMode = .scaleAspectFit
        deleteImageView.image = UIImage(systemName: "minus.circle")
        deleteImageView.tintColor = .red
        deleteImageView.isHidden = true
    }
    
}
