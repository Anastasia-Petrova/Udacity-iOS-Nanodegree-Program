//
//  PitchPerfectTests.swift
//  PitchPerfectTests
//
//  Created by Anastasia Petrova on 16/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import XCTest
@testable import PitchPerfect

final class PitchPerfectTests: XCTestCase {
    func test_effectType_initButtonTag_returns_correctResult() {
        let effect0 = PlaySoundsViewController.EffectType(buttonTag: 0)
        let effect1 = PlaySoundsViewController.EffectType(buttonTag: 1)
        let effect2 = PlaySoundsViewController.EffectType(buttonTag: 2)
        let effect3 = PlaySoundsViewController.EffectType(buttonTag: 3)
        let effect4 = PlaySoundsViewController.EffectType(buttonTag: 4)
        let effect5 = PlaySoundsViewController.EffectType(buttonTag: 5)
        let effect6 = PlaySoundsViewController.EffectType(buttonTag: 6)
        
        XCTAssertEqual(effect0, .slow(rate: 0.5))
        XCTAssertEqual(effect1, .fast(rate: 1.5))
        XCTAssertEqual(effect2, .chipmunk(pitch: 1000))
        XCTAssertEqual(effect3, .vader(pitch: -1000))
        XCTAssertEqual(effect4, .echo(isEnabled: true))
        XCTAssertEqual(effect5, .reverb(isEnabled: true))
        XCTAssertNil(effect6)
    }
}
