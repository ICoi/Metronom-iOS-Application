//
//  AudioPlayerView.swift
//  Metronom
//
//  Created by 정다운 on 8/12/24.
//

import SwiftUI

struct AudioPlayerView: View {
    let item: String

    @StateObject private var audioPlayer = AudioPlayer()
    @State private var isPlaying = false

    var body: some View {
        VStack {
            Text("Audio Player")
                .font(.title)
                .padding()

            HStack {
                Button(action: {
                    if isPlaying {
                        audioPlayer.pause()
                    } else {
                        audioPlayer.play()
                    }
                    isPlaying.toggle()
                }) {
                    Text(isPlaying ? "Pause" : "Play")
                        .padding()
                        .background(isPlaying ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    audioPlayer.stop()
                    isPlaying = false
                }) {
                    Text("Stop")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .onAppear {
            let components = item.components(separatedBy: ".")
            audioPlayer.loadAudio(fileName: components[0], fileType: components[1]) // Replace with your audio file name and type
        }
    }
}
