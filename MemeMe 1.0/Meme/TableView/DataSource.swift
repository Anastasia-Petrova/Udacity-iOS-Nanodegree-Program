//
//  TableViewDataSource.swift
//  Meme
//
//  Created by Anastasia Petrova on 22/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class DataSource: NSObject {
    var memesImagesForIndex: [Int : UIImage] = [:]
    var memes: [MemeModel]
    var data: [(text: String, image: UIImage)]
    
    var isEditModeOn: Bool = false
    
    override init() {
        memes = (try? MemesStorage.loadMemes()) ?? []
        data = Self.mapMemesToData(memes)
        super.init()
    }
    
    
    func reloadData() {
        memes = (try? MemesStorage.loadMemes()) ?? []
        data = Self.mapMemesToData(memes)
    }
    
    static func mapMemesToData(_ memes: [MemeModel]) -> [(text: String, image: UIImage)] {
        memes
            .sorted(by: { $1.date > $0.date })
            .compactMap {
            if let image = ImageStorage.getImage(id: $0.id) {
                return ($0.text, image)
            } else {
                return nil
            }
        }
    }
    
    func deleteMeme(indexPath: IndexPath) {
        memes.remove(at: indexPath.row)
        let encodedData = try! JSONEncoder().encode(memes)
        UserDefaults.standard.set(encodedData, forKey: "memes")
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
        cell.memeName.text = data[indexPath.row].text
        cell.memeImageView.image = data[indexPath.row].image
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try ImageStorage.deleteImage(id: memes[indexPath.row].id)
                deleteMeme(indexPath: indexPath)
                tableView.deleteRows(at: [indexPath], with: .fade)
                reloadData()
            } catch {
                print(error)
            }
        } 
    }
}

extension MemeModel {
    var text: String {
        topText + "..." + bottomText
    }
}
