//
//  SavedMemesDataSource.swift
//  Meme
//
//  Created by Anastasia Petrova on 08/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class SavedMemesDataSource: NSObject {
    var memeViewModels: [MemeViewModel] = []
    var isEditModeOn: Bool = false
    
    override init() {
        super.init()
        reloadData()
    }
    
    func reloadData() {
        memeViewModels = MemeStore
            .loadMemes()
            .sorted(by: { $1.date > $0.date })
            .compactMap { meme in
                ImageStore
                    .getImage(id: meme.id)
                    .map { MemeViewModel(meme: meme, image: $0) }
            }
    }
    
    func deleteMeme(at indexPath: IndexPath) {
        try? ImageStore.deleteImage(id: memeViewModels[indexPath.row].id)
        MemeStore.deleteMeme(id: memeViewModels[indexPath.row].id)
        reloadData()
    }
}

extension SavedMemesDataSource {
    struct MemeViewModel {
        let id: UUID
        let text: String
        let image: UIImage
    }
}

extension SavedMemesDataSource.MemeViewModel {
    init(meme: Meme, image: UIImage) {
        id = meme.id
        text = meme.topText + "..." + meme.bottomText
        self.image = image
    }
}

//MARK: - UITableViewDataSource

extension SavedMemesDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memeViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SavedMemesTableCell.identifier, for: indexPath) as! SavedMemesTableCell
        cell.memeName.text = memeViewModels[indexPath.row].text
        cell.memeImageView.image = memeViewModels[indexPath.row].image
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteMeme(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

//MARK: - UICollectionViewDataSource

extension SavedMemesDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memeViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedMemesCollectionCell.identifier, for: indexPath) as! SavedMemesCollectionCell
        
        cell.memeImageView.image = memeViewModels[indexPath.row].image
        return cell
    }
}
