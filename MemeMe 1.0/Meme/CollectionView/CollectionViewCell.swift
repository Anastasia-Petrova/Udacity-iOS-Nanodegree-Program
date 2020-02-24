//
//  CollectionViewCell.swift
//  Meme
//
//  Created by Anastasia Petrova on 24/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    let memeImageView = UIImageView()
    
    override init(frame: CGRect) {
    super.init(frame: frame)
        self.contentView.addSubview(memeImageView)
        NSLayoutConstraint.activate([
            memeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            memeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            memeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            memeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        memeImageView.contentMode = .scaleToFill
        memeImageView.clipsToBounds = true
        self.backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
