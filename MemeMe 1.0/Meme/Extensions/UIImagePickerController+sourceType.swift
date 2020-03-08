//
//  PhotoLibraryBrowser.swift
//  Meme
//
//  Created by Anastasia Petrova on 17/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import AVFoundation
import MobileCoreServices
import UIKit

extension UIImagePickerController {
    convenience init?(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            return nil
        }
        self.init()
        self.sourceType = sourceType
        self.mediaTypes = [kUTTypeImage as String]
    }
}
