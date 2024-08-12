//
//  TestItem.swift
//  Metronom
//
//  Created by 정다운 on 8/12/24.
//

import UIKit

import SwiftUI
import Combine

// 테스트용
class ItemStore: ObservableObject {
    @Published var items: [String] = [] // 외부 데이터
    
    // 데이터 추가를 위한 메서드
    func addItem(_ item: String) {
        items.append(item)
    }
}
