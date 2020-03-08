//
//  DataSource.swift
//  Meme
//
//  Created by Anastasia Petrova on 08/03/2020.
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
