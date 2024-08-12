//
//  MainView.swift
//  Metronom
//
//  Created by 정다운 on 8/10/24.
//

import SwiftUI
import RxSwift

struct MainView: View {
    let beef = BeefGenerator()
    let timer = BPMTimer(bpm: 100)
    let recorder = AudioRecorder()
    let disposeBag: DisposeBag = DisposeBag()
    
    @State private var speed: Int = 80
    @State private var isPlaying: Bool = false // 메트로놈 소리 진행 중인지 여부
    @State private var isRecording: Bool = false // 녹음 진행 중인지 여부
    
    var body: some View {
        VStack {
            displayView
            buttonBar
            documentButtonBar
        }
        .padding()
    }
    
    var displayView: some View {
        HStack {
            Button("-") {
                speed -= 1
            }
            .font(.system(size: 50))
            .frame(width: 80, height: 80)
            Button("\(speed)") {
                
            }
            .font(.system(size: 80))
            .frame(minWidth: 150, maxWidth: 200)
            Button("+") {
                speed += 1
            }
            .font(.system(size: 50))
            .frame(width: 80, height: 80)
        }
    }
    
    var buttonBar: some View {
        HStack {
            // 왼쪽 버튼
           Button(action: {
               print("Left Button Pressed")
               timer.start()
               timer.observe().subscribe(onNext: { _ in
                   beef.play()
               }).disposed(by: disposeBag)
           }) {
               Text("시작! 재생!")
                   .frame(maxWidth: .infinity)
                   .padding()
                   .background(Color.blue)
                   .foregroundColor(.white)
                   .cornerRadius(8)
           }
           .buttonStyle(.bordered)
           .tint(.pink)
           .frame(width: UIScreen.main.bounds.width * 0.7) // 화면 너비의 70%로 설정

           // 오른쪽 버튼
           Button(action: {
               print("Right Button Pressed")
               if isRecording == false {
                   // 중지 상태이므로 녹음 시작
                   recorder.startRecording()
               } else {
                   // 녹음 중이므로 중지 한다
                   recorder.stopRecording()
               }
               isRecording.toggle()
           }) {
               Text(isRecording ? "녹음 시작" : "녹음 중단")
                   .frame(maxWidth: .infinity)
                   .padding()
                   .background(Color.green)
                   .foregroundColor(.white)
                   .cornerRadius(8)
           }
           .buttonStyle(.bordered)
           .tint(.pink)
           .frame(width: UIScreen.main.bounds.width * 0.3) // 화면 너비의 30%로 설정
        }
//        .background(Color.blue)
        .frame(maxWidth: .infinity)
    }
    
    var documentButtonBar: some View {
        NavigationLink(destination: DocumentView()) {
            Text("다음 화면으로 이동")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .font(.title)
        }
        .navigationTitle("메인 화면") // 현재 화면의 제목 설정
    }
}

#Preview {
    MainView()
}
