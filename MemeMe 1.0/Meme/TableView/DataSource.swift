//
//  TableViewDataSource.swift
//  Meme
//
//  Created by Anastasia Petrova on 22/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class DataSource: NSObject {
    struct MemeViewModel {
        let meme: MemeModel
        let image: UIImage
    }
    
    var memes: [MemeViewModel]
    
    var isEditModeOn: Bool = false
    
    override init() {
        let memeModels = MemeStore.loadMemes()
        memes = Self.mapMemesToViewModels(memeModels)
        super.init()
    }
    
    func reloadData() {
        let memeModels = MemeStore.loadMemes()
        memes = Self.mapMemesToViewModels(memeModels)
    }
    
    static func mapMemesToViewModels(_ memes: [MemeModel]) -> [MemeViewModel] {
        memes
            .sorted(by: { $1.date > $0.date })
            .compactMap {
                if let image = ImageStore.getImage(id: $0.id) {
                    return MemeViewModel(
                        meme: $0,
                        image: image
                    )
                } else {
                    return nil
                }
        }
    }
    
    func deleteMeme(indexPath: IndexPath) {
        memes.remove(at: indexPath.row)
        if let encodedData = try? JSONEncoder().encode(memes.map { $0.meme }) {
            UserDefaults.standard.set(encodedData, forKey: "memes")
        }
    }
}

extension DataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.memeImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        cell.memeName.text = memes[indexPath.row].text
        cell.memeImageView.image = memes[indexPath.row].image
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try ImageStore.deleteImage(id: memes[indexPath.row].meme.id)
                deleteMeme(indexPath: indexPath)
                tableView.deleteRows(at: [indexPath], with: .fade)
                reloadData()
            } catch {
                print(error)
            }
        } 
    }
}

extension DataSource.MemeViewModel {
    var text: String {
        meme.topText + "..." + meme.bottomText
    }
}
