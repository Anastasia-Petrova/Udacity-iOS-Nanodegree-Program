//
//  MemeTests.swift
//  MemeTests
//
//  Created by Anastasia Petrova on 21/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

@testable import Meme
import XCTest

final class MemeTests: XCTestCase {
    func test_rendering_portrait() throws {
        XCUIDevice.shared.orientation = .portrait
        let vc = MemeEditorViewController {}
        vc.photoView.image = UIImage(named: "original", in: .unitTests, with: nil)
        vc.view.layoutIfNeeded()
        
        let actualImageURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("actualImage.png")
        try vc.renderMemeImage()?.pngData()?.write(to: actualImageURL)
        let actualImage = UIImage(contentsOfFile: actualImageURL.path)
        
        let expectedImageUrl = URL(fileURLWithPath: "\(#file)", isDirectory: false)
            .deletingLastPathComponent()
            .appendingPathComponent("expectedImage_portrait.png")
        let expectedImage = UIImage(contentsOfFile: expectedImageUrl.path)
        
        XCTAssertEqual(actualImage?.pngData(), expectedImage?.pngData())
    }
    
    func test_rendering_landscape() throws {
        XCUIDevice.shared.orientation = .landscapeLeft
        let vc = MemeEditorViewController {}
        vc.photoView.image = UIImage(named: "original", in: .unitTests, with: nil)
        vc.view.layoutIfNeeded()
        
        let actualImageURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("actualImage_landscape.png")
        try vc.renderMemeImage()?.pngData()?.write(to: actualImageURL)
        let actualImage = UIImage(contentsOfFile: actualImageURL.path)
        
        let expectedImageUrl = URL(fileURLWithPath: "\(#file)", isDirectory: false)
            .deletingLastPathComponent()
            .appendingPathComponent("expectedImage_landscape.png")
        let expectedImage = UIImage(contentsOfFile: expectedImageUrl.path)
        
        XCTAssertEqual(actualImage?.pngData(), expectedImage?.pngData())
    }
}
