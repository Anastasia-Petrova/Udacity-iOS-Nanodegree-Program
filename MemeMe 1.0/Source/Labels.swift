//
//  Labels.swift
//  Meme
//
//  Created by Anastasia Petrova on 01/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation

enum Labels {
    enum EditorScreen {
        static let instructionText = "Pick an Image"
        
        enum TextField {
            static let topText = "TOP"
            static let bottomText = "BOTTOM"
        }
        enum Toolbar {
            static let cameraButtonImageName = "camera.fill"
            static let albumButtonTitle = "Album"
        }
        enum Alert {
            static let createMemeErrorText = "Couldn't create your meme 😦"
            static let createMemeErrorDescription = "Did you forget to pick an image?"
            static let saveErrorText = "Couldn't save your meme 😦"
            static let unrecoverableSaveErrorDescription =
            """
            Oops! Something went wrong.
            Please check for new updates. We have probably fixed this problem already! 🚀
            """
            static let okButtonTitle = "OK"
        }
    }
    
    enum ImageStorage {
        enum Error {
            static let imageNotFoundTitle = "Image Not Found"
            static let imageNotFoundDescription = "Looks like your image is empty. Try another one."
        }
    }
    
    enum SavedMemesScreen {
        static let title = "Sent Memes"
    }
}
