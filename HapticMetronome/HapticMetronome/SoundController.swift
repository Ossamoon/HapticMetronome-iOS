//
//  SoundController.swift
//  HapticMetronome
//
//  Created by 齋藤修 on 2020/12/30.
//

import Foundation
import AVFoundation

class SoundController: NSObject, AVAudioPlayerDelegate {
    
    private var counter: Int
    private let numberOfAudioPlayer: Int = 5
    private var audioPlayers: [AVAudioPlayer] = []
    
    override init() {
        counter = 0
        if let path = Bundle.main.path(forResource: "sound1", ofType: "aif") {
            do {
                for i in (0 ..< numberOfAudioPlayer) {
                    let audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                    self.audioPlayers.append(audioPlayer)
                    print("Create audioPlayer " + String(i))
                }
            } catch {
                print( "Could not find file")
            }
        }
    }
    
    func prepare() {
        for i in (0 ..< numberOfAudioPlayer) {
            print("Prepare audioPlayer " + String(i))
            audioPlayers[i].prepareToPlay()
        }
    }
    
    func play() {
        audioPlayers[counter].play()
        print("Play audioPlayer " + String(counter))
        counter += 1
        if counter >= numberOfAudioPlayer{
            counter = 0
        }
    }
    
    func stop() {
        for i in (0 ..< numberOfAudioPlayer) {
            print("Undoes the setup for audioPlayer " + String(i))
            audioPlayers[i].stop()
        }
    }
}
