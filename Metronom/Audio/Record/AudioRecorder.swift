//
//  AudioRecorder.swift
//  Metronom
//
//  Created by 정다운 on 8/11/24.
//

import AVFoundation

import AVFoundation

class AudioRecorder: NSObject {
    private var audioRecorder: AVAudioRecorder?
    private let audioSession = AVAudioSession.sharedInstance()
    
    private let audioEngine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private let mixerNode = AVAudioMixerNode()
    private let inputNode: AVAudioInputNode
    private var audioFile: AVAudioFile?

    override init() {
        self.inputNode = audioEngine.inputNode
        
        super.init()
        
        setupAudioSession()
        setupAudioEngine()
    }

    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }

    private func setupAudioEngine() {
        // Attach nodes
        audioEngine.attach(playerNode)
        audioEngine.attach(mixerNode)
        
        // Connect nodes
        audioEngine.connect(playerNode, to: mixerNode, format: nil)
        audioEngine.connect(inputNode, to: mixerNode, format: inputNode.inputFormat(forBus: 0))
        audioEngine.connect(mixerNode, to: audioEngine.mainMixerNode, format: nil)
        
        // Prepare and start the audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Failed to start audio engine: \(error.localizedDescription)")
        }
    }
    func startRecording() {
        
        let fileName = UUID().uuidString + ".m4a"
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        let format = audioEngine.outputNode.outputFormat(forBus: 0)
        do {
            audioFile = try AVAudioFile(forWriting: fileURL, settings: format.settings)
            print("경로 : \(fileURL)")
        } catch {
            print("Error creating audio file: \(error.localizedDescription)")
            return
        }
        playSound(frequency: 1000.0, duration: 0.1)
        
        audioEngine.mainMixerNode.installTap(onBus: 0, bufferSize: 4096, format: format) { (buffer, when) in
            do {
                try self.audioFile?.write(from: buffer)
            } catch {
                print("Error writing audio buffer: \(error.localizedDescription)")
            }
        }
    }
    
    func playSound(frequency: Double, duration: Double) {
        let sampleRate = 44100.0
        let amplitude = 0.1
        let sampleCount = Int(sampleRate * duration)
        let sampleBuffer = AVAudioPCMBuffer(pcmFormat: audioEngine.mainMixerNode.outputFormat(forBus: 0), frameCapacity: AVAudioFrameCount(sampleCount))

        sampleBuffer?.frameLength = AVAudioFrameCount(sampleCount)
        let samples = sampleBuffer?.floatChannelData?[0]

        let thetaIncrement = 2.0 * Double.pi * frequency / sampleRate
        var theta = 0.0

        for i in 0..<sampleCount {
            samples?[i] = Float(amplitude * sin(theta))
            theta += thetaIncrement
        }

        playerNode.scheduleBuffer(sampleBuffer!, at: nil, options: .interrupts, completionHandler: nil)
        playerNode.play()
    }

    func stopRecording() {
        audioEngine.mainMixerNode.removeTap(onBus: 0)
        playerNode.stop()
        audioEngine.stop()
        audioFile = nil
//        audioRecorder?.stop()
//        audioRecorder = nil
//        print("Recording stopped.")
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

// MARK: - AVAudioRecorderDelegate
extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Recording successfully finished.")
        } else {
            print("Recording failed.")
        }
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Recording encode error: \(error?.localizedDescription ?? "Unknown error")")
    }
}
