//
//  SoundManager.swift
//  Nicoboo
//
//  Created to handle Zippo and firework sounds.
//

import Foundation
import AVFoundation

final class SoundManager: NSObject, AVAudioPlayerDelegate {
    static let shared = SoundManager()
    
    private var openPlayer: AVAudioPlayer?
    private var fireworkPlayer: AVAudioPlayer?
    
    private override init() {
        super.init()
        configureAudioSession()
        preparePlayers()
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("SoundManager: Failed to configure audio session: \(error)")
        }
    }
    
    private func preparePlayers() {
        if let openUrl = Bundle.main.url(forResource: "open", withExtension: "wav") {
            do {
                let player = try AVAudioPlayer(contentsOf: openUrl)
                player.volume = 1.0
                player.delegate = self
                player.prepareToPlay()
                openPlayer = player
            } catch {
                print("SoundManager: Failed to load open.wav: \(error)")
            }
        } else {
            print("SoundManager: open.wav not found in bundle")
        }
        
        if let fireworkUrl = Bundle.main.url(forResource: "firework", withExtension: "mp3") {
            do {
                let player = try AVAudioPlayer(contentsOf: fireworkUrl)
                player.numberOfLoops = -1 // loop indefinitely
                player.prepareToPlay()
                fireworkPlayer = player
            } catch {
                print("SoundManager: Failed to load firework.mp3: \(error)")
            }
        } else {
            print("SoundManager: firework.mp3 not found in bundle")
        }
    }
    
    /// Play open sound once, then immediately start looping firework sound.
    func playOpenThenLoopFirework() {
        stopFirework()
        
        if openPlayer == nil || fireworkPlayer == nil {
            // Try to re-prepare in case resources were added later
            preparePlayers()
        }
        
        openPlayer?.stop()
        openPlayer?.currentTime = 0
        openPlayer?.play()
        
        // 根据你的需求：不需要等 open 完全播完，点击就可以直接开始 firework 循环
        startFireworkLoop()
    }
    
    /// Start looping firework sound (if available).
    private func startFireworkLoop() {
        if fireworkPlayer == nil {
            preparePlayers()
        }
        
        fireworkPlayer?.stop()
        fireworkPlayer?.currentTime = 0
        fireworkPlayer?.numberOfLoops = -1
        fireworkPlayer?.play()
    }
    
    /// Stop firework looping sound.
    func stopFirework() {
        fireworkPlayer?.stop()
    }
    
    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Currently not used to trigger anything; logic is immediate start of firework.
    }
}


