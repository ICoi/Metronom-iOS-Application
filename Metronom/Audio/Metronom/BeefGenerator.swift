//
//  BeefGenerator.swift
//  Metronom
//
//  Created by 정다운 on 8/10/24.
//

import AVFoundation

class BeefGenerator {
    let audioEngine: AVAudioEngine
    let oscillator: AVAudioPlayerNode
    let mixerNode: AVAudioMixerNode
    
    init() {
        audioEngine = AVAudioEngine()
        oscillator = AVAudioPlayerNode()
        
        // 볼륨 크기를 조절을 위한 mixner node를 생성합니다.
        mixerNode = audioEngine.mainMixerNode
        
        // 설치하기: oscillator를 오디오 엔진의 입력에 연결합니다.
        audioEngine.attach(oscillator)

        // 오디오 엔진의 출력을 출력 장치에 연결합니다.
        audioEngine.connect(oscillator, to: mixerNode, format: nil)

        // 볼륨 조정
        mixerNode.outputVolume = 1.0
        // 오디오 엔진 시작
        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
    }

    func play() {
        print("BEEFFFF!")
        playSound(frequency: 1000.0, duration: 0.1)
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

        oscillator.scheduleBuffer(sampleBuffer!, at: nil, options: .interrupts, completionHandler: nil)
        oscillator.play()
    }

    func stopSound() {
        oscillator.stop()
    }
}
