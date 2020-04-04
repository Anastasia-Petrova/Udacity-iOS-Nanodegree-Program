//
//  AlbumCollectionDataSource.swift
//  VirtualTourist
//
//  Created by Anastasia Petrova on 04/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

class AlbumCollectionDataSource: NSObject, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
               let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MapCollectionHeader", for: indexPath)
               return headerView

        default:  fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionCell.identifier, for: indexPath) as! PhotosCollectionCell
        cell.photoImageView.image = UIImage(named: "launchScreen")
        return cell
    }
}
