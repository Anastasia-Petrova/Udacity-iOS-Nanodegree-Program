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
    lazy var memes = decodeData()

    func decodeData() -> [MemeModel] {
        guard let encodedData = UserDefaults.standard.data(forKey: "memes") else {
            return []
        }
        return try! JSONDecoder().decode([MemeModel].self, from: encodedData)
    }
    
    func getAllIMages() -> [(text: String, image: UIImage)] {
        let sortedMemes = memes.sorted(by: { $1.date > $0.date })
        var textAndImagesArray: [(String, UIImage)] = []
        sortedMemes.forEach { meme in
            let text = meme.topTetx + "..." + meme.bottomText
            let directoryURL = ImageStorage.memesDirectory.appendingPathComponent(meme.id.uuidString)
            if let image = UIImage(contentsOfFile: directoryURL.path) {
                textAndImagesArray.append((text, image))
            }
        }
        return textAndImagesArray
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
        let textAndImageArray = getAllIMages()
        cell.memeName.text = textAndImageArray[indexPath.row].text
        cell.memeImageView.image = textAndImageArray[indexPath.row].image
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteMeme(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } 
    }
}
