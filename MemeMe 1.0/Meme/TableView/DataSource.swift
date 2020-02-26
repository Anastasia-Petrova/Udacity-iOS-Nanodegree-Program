//
//  TableViewDataSource.swift
//  Meme
//
//  Created by Anastasia Petrova on 22/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class DataSource: NSObject {
    let userStorage = UserStorage()
    var cellForItemCallback: (() -> Void)?
}

extension DataSource: UITableViewDataSource {
    
    //TODO: create enum MemesStorage with API:
    //getAllMemes
    //deleteAllMemes
    //addMeme
    //removeMeme
    func decodeData() -> [MemeModel]{
        guard let encodedData = UserDefaults.standard.data(forKey: "memes") else {
            return []
        }
        return try! JSONDecoder().decode([MemeModel].self, from: encodedData)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(decodeData().count)
        return decodeData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.memeImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        //TODO: Load memes once and assign to property
        let memesArray = decodeData()
        let meme = memesArray[indexPath.row]
        cell.memeName.text = meme.topTetx + " " + meme.bottomText

        let directoryURL = UserStorage.memesDirectory.appendingPathComponent(meme.id.uuidString)
        cell.memeImageView.image = UIImage(contentsOfFile: directoryURL.path)
        return cell
    }
}
