//
//  AudioPlayerView.swift
//  Metronom
//
//  Created by 정다운 on 8/12/24.
//

import SwiftUI

struct AudioPlayerView: View {
    let item: String
    
    var body: some View {
        VStack {
            Text("선택한 항목: \(item)")
                .font(.largeTitle)
                .padding()
            
            // 상세 정보나 추가 UI 요소를 여기에 배치
        }
        .navigationTitle("상세 화면") // 네비게이션 바의 제목
    }
}
