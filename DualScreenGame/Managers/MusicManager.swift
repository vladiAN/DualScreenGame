//
//  MusicManager.swift
//  DualScreenGame
//
//  Created by Алина Андрушок on 12.04.2023.
//

import AVFoundation

class MusicManager {
    
    private init() {}
    
    static let shared = MusicManager()
    
    let defaults = UserDefaultManager.shared
    
    var bgAudioPlayer: AVAudioPlayer?
    var soundEffectsDict: [String: AVAudioPlayer] = [:]
    
    
    
    func playBackgroundMusic() {
        if defaults.musicEffectsIsOn {
            if let bundle = Bundle.main.path(forResource: "music", ofType: "mp3") {
                let backgroundMusic = NSURL(fileURLWithPath: bundle)
                do {
                    bgAudioPlayer = try AVAudioPlayer(contentsOf: backgroundMusic as URL)
                    guard let audioPlayer = bgAudioPlayer else { return }
                    audioPlayer.numberOfLoops = -1
                    audioPlayer.play()
                } catch {
                    print("Cloud not load background music file")
                }
            }
        } else {
            bgAudioPlayer?.stop()
            bgAudioPlayer = nil
        }
    }
    
    func stopBackgroundMusic() {
        bgAudioPlayer?.stop()
        bgAudioPlayer = nil
    }
    
    func loadSoundEffects() {
        
        let soundEffectsFiles = [
            "click",
            "coin1",
            "coin2",
            "die",
            "gameOver",
            "tap"
        ]
        
        for file in soundEffectsFiles {
            if let soundURL = Bundle.main.url(forResource: file, withExtension: "mp3") {
                do {
                    let soundEffect = try AVAudioPlayer(contentsOf: soundURL)
                    soundEffectsDict[file] = soundEffect
                } catch {
                    print("Error loading sound effect file: \(file)")
                }
            } else {
                print("Error loading sound effect file: \(file)")
            }
        }
    }
    
    func soundEffects(fileName: String) {
        if defaults.musicEffectsIsOn {
            if let sound = soundEffectsDict[fileName] {
                sound.currentTime = 0
                sound.play()
            }
        } else { return }
    }
        

}

