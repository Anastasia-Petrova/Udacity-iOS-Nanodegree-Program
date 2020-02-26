//
//  CollectionViewDataSource.swift
//  Meme
//
//  Created by Anastasia Petrova on 24/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

extension DataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let memes = userStorage.getAllImages()
        return memes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        //TODO: Load images once and assign to property images: [UIImage]
        let memes = userStorage.getAllImages()
        cell.memeImageView.image = memes[indexPath.row]
        return cell
    }
}
