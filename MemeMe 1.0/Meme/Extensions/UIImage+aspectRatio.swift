//
//  UIImage+aspectRatio.swift
//  Meme
//
//  Created by Anastasia Petrova on 08/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

extension UIImage {
    func aspectRatio(isPortrait: Bool) -> CGFloat {
        let dividend = isPortrait ? size.height : size.width
        let denominator = isPortrait ? size.width : size.height
        guard denominator > 0 else {
            return 0
        }
        return dividend/denominator
    }
}
