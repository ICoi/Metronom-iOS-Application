//
//  ContentView.swift
//  Metronom
//
//  Created by 정다운 on 8/10/24.
//

import SwiftUI
import RxSwift

struct ContentView: View {
    let beef = BeefGenerator()
    let timer = BPMTimer(bpm: 100)
    let recorder = AudioRecorder()
    let disposeBag: DisposeBag = DisposeBag()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("소리 내기") {
                // TODO
                beef.play()
            }
            Button("timer start") {
                // TODO
                timer.start()
                timer.observe().subscribe(onNext: { _ in
                    beef.play()
                }).disposed(by: disposeBag)
            }
            Button("녹음하기") {
                // TODO
                recorder.startRecording()
            }
            
            Button("녹음 끝") {
                recorder.stopRecording()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
