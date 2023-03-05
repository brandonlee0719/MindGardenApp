//
//  Sound.swift
//  MindGarden
//
//  Created by Vishal Davara on 11/04/22.
//

import Foundation
import AVFoundation
class MGAudio: NSObject, AVAudioPlayerDelegate {
    
    static let sharedInstance = MGAudio()
    
    private override init() { }
    
    var players: [URL: AVAudioPlayer] = [:]
    var duplicatePlayers: [AVAudioPlayer] = []
    
    func playSound(soundFileName: String) {
        if let bundle = Bundle.main.path(forResource: soundFileName, ofType: nil) {
            let soundFileNameURL = URL(fileURLWithPath: bundle)
            
            if let player = players[soundFileNameURL] { //player for sound has been found
            
                    player.volume = 0.4
                if !player.isPlaying { //player is not in use, so use that one
                    player.prepareToPlay()
                    player.play()
                } else { // player is in use, create a new, duplicate, player and use that instead
                    
                    do {
                        let duplicatePlayer = try AVAudioPlayer(contentsOf: soundFileNameURL)
                        
                        duplicatePlayer.delegate = self
                        //assign delegate for duplicatePlayer so delegate can remove the duplicate once it's stopped playing
                        
                        duplicatePlayers.append(duplicatePlayer)
                        //add duplicate to array so it doesn't get removed from memory before finishing
                        
                        duplicatePlayer.prepareToPlay()
                        duplicatePlayer.play()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                    
                }
            } else { //player has not been found, create a new player with the URL if possible
                do {
                  
                    let player = try AVAudioPlayer(contentsOf: soundFileNameURL)
                    if soundFileName == "waterdrops.mp3" {
                        player.volume = 0.07
                    } else {
                        player.volume = 0.4
                    }
                    players[soundFileNameURL] = player
                    player.prepareToPlay()
                    player.play()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func stopSound(){
         players = [:]
         duplicatePlayers = []
    }
    
    func playSounds(soundFileNames: [String]) {
        for soundFileName in soundFileNames {
            playSound(soundFileName: soundFileName)
        }
    }
    
    func playSounds(soundFileNames: String...) {
        for soundFileName in soundFileNames {
            playSound(soundFileName: soundFileName)
        }
    }
    
    func playSounds(soundFileNames: [String], withDelay: Double) { //withDelay is in seconds
        for (index, soundFileName) in soundFileNames.enumerated() {
            let delay = withDelay * Double(index)
            let _ = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(playSoundNotification(_:)), userInfo: ["fileName": soundFileName], repeats: false)
        }
    }
    
    @objc func playSoundNotification(_ notification: NSNotification) {
        if let soundFileName = notification.userInfo?["fileName"] as? String {
            playSound(soundFileName: soundFileName)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let index = duplicatePlayers.firstIndex(of: player) {
            duplicatePlayers.remove(at: index)
        }
    }
    
    func playBubbleSound(){
        DispatchQueue.main.async {
            MGAudio.sharedInstance.stopSound()
            
            MGAudio.sharedInstance.playSound(soundFileName: "waterdrops.mp3")
        }
    }
    
}
