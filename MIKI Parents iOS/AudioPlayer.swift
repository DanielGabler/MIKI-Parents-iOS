//
//  AusioPlayer.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 08.10.24.
//

import AVFoundation

class AudioPlayer {
    static let shared = AudioPlayer()
    
    private var player: AVAudioPlayer?
    
    func playSound(soundFileName: String) {
        guard let url = Bundle.main.url(forResource: soundFileName, withExtension: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch let error {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
