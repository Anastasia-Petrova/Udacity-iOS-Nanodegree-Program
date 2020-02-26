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
        let meme = memes[indexPath.row]
        cell.memeName.text = meme.topTetx + " " + meme.bottomText
        if memesImagesForIndex[indexPath.row] != nil {
            cell.memeImageView.image = memesImagesForIndex[indexPath.row]
        } else {
            let directoryURL = ImageStorage.memesDirectory.appendingPathComponent(meme.id.uuidString)
            let image = UIImage(contentsOfFile: directoryURL.path)
            cell.memeImageView.image = image
            memesImagesForIndex[indexPath.row] = image
//            tableView.reloadRows(at: [indexPath], with: .none)
        }
        return cell
    }
}
