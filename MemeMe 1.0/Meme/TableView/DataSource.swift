//
//  TableViewDataSource.swift
//  Meme
//
//  Created by Anastasia Petrova on 22/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class DataSource: NSObject {
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

extension DataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memeViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
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

extension DataSource {
    struct MemeViewModel {
        let id: UUID
        let text: String
        let image: UIImage
    }
}

extension DataSource.MemeViewModel {
    init(meme: Meme, image: UIImage) {
        id = meme.id
        text = meme.topText + "..." + meme.bottomText
        self.image = image
    }
}
