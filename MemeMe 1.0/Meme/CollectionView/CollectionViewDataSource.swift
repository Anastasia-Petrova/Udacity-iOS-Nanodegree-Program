//
//  CollectionViewDataSource.swift
//  Meme
//
//  Created by Anastasia Petrova on 24/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

extension DataSource: UICollectionViewDataSource {
    
    //TODO: Rename. Its not a transform. It does not set up anything. This name is shite.
    func setUpTransform(indexPath: IndexPath) -> CAKeyframeAnimation {
        let transformAnim  = CAKeyframeAnimation(keyPath:"transform")
        transformAnim.values  = [NSValue(caTransform3D: CATransform3DMakeRotation(0.04, 0.0, 0.0, 1.0)),NSValue(caTransform3D: CATransform3DMakeRotation(-0.04 , 0, 0, 1))]
        transformAnim.autoreverses = true
        transformAnim.duration  = (Double(indexPath.row).truncatingRemainder(dividingBy: 2.0)) == 0 ? 0.115 : 0.105
        transformAnim.repeatCount = Float.infinity
        return transformAnim
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.memeImageView.image = data[indexPath.row].image
        if isEditModeOn {
            cell.deleteImageView.isHidden = false
            let transform = setUpTransform(indexPath: indexPath)
            cell.layer.add(transform, forKey: "transform")
        } else {
            cell.deleteImageView.isHidden = true
            cell.layer.removeAllAnimations()
        }
        
        //TODO: pass callback to each cell to perform deletion
//        cell.didTapDeleteButton = { [weak self] in
//            self.deleteMeme(indexPath: indexPath)
//            collectionView.deleteItems(at: [indexPath])
//            self.reloadData()
//        }
        return cell
    }
}
