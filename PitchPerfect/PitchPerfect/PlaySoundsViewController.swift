//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Anastasia Petrova on 15/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import AVFoundation
import UIKit

final class PlaySoundsViewController: UIViewController {
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var recordedAudioURL: URL!
    var stopTimer: Timer!
    
    @IBOutlet var chipmunkButton: UIButton!
    @IBOutlet var echoButton: UIButton!
    @IBOutlet var snailButton: UIButton!
    @IBOutlet var rabbitButton: UIButton!
    @IBOutlet var reverbButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var vaderButton: UIButton!
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch(EffectType(buttonTag: sender.tag)!) {
        case let .slow(rate),
             let .fast(rate):
            playSound(rate: rate)
        case let .chipmunk(pitch),
             let .vader(pitch):
            playSound(pitch: pitch)
        case let .echo(isEnabled):
            playSound(echo: isEnabled)
        case let .reverb(isEnabled):
            playSound(reverb: isEnabled)
        }

        configureUI(.playing)
    }

    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
}

extension PlaySoundsViewController {
    enum EffectType: Equatable {
        case slow(rate: Float)
        case fast(rate: Float)
        case chipmunk(pitch: Float)
        case vader(pitch: Float)
        case echo(isEnabled: Bool)
        case reverb(isEnabled: Bool)
        
        init?(buttonTag: Int) {
            switch buttonTag {
            case 0: self = .slow(rate: 0.5)
            case 1: self = .fast(rate: 1.5)
            case 2: self = .chipmunk(pitch: 1000)
            case 3: self = .vader(pitch: -1000)
            case 4: self = .echo(isEnabled: true)
            case 5: self = .reverb(isEnabled: true)
            default: return nil
            }
        }
    }
}
