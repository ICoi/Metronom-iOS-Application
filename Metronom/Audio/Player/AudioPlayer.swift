//
//  AudioPlayer.swift
//  Metronom
//
//  Created by 정다운 on 8/14/24.
//

import UIKit

import AVFoundation

class AudioPlayer: ObservableObject {
    private var player: AVAudioPlayer?
    @Published var isPlaying = false

    func loadAudio(fileName: String, fileType: String) {
        guard let url = DocumentManager().getPath?.appendingPathComponent("\(fileName).\(fileType)") else {
            return
        }
//        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileType) else {
//            print("Audio file not found.")
//            return
//        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
        } catch {
            print("Error initializing AVAudioPlayer: \(error.localizedDescription)")
        }
    }

    func play() {
        player?.play()
        isPlaying = true
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func stop() {
        player?.stop()
        player?.currentTime = 0
        isPlaying = false
    }
}
