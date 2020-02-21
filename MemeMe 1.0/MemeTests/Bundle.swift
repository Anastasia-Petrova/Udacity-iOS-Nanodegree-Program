//
//  TesrBundle.swift
//  MemeTests
//
//  Created by Anastasia Petrova on 21/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation

extension Bundle {
    static let unitTests = Bundle(for: BundleLocator.self)
}

private class BundleLocator {}
