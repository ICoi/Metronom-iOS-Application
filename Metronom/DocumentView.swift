//
//  DocumentView.swift
//  Metronom
//
//  Created by 정다운 on 8/12/24.
//

import SwiftUI
import Combine

// Model
struct Item {
    let id: UUID
    let name: String
}

// ViewModel
class ItemViewModel: ObservableObject {
    @Published var items: [Item] = [Item(id: UUID(), name: "a"),
                                    Item(id: UUID(), name: "b"),
                                    Item(id: UUID(), name: "c")]
    
    func addItem(name: String) {
        let newItem = Item(id: UUID(), name: name)
        items.append(newItem)
    }
}

struct DocumentView: View {
    @StateObject private var viewModel = ItemViewModel()
    
    let items = ["아이템 1", "아이템 2", "아이템 3", "아이템 4"] // 목록에 표시할 데이터
    
    var body: some View {
        List(viewModel.items, id: \.id) { item in
            NavigationLink(destination: AudioPlayerView(item: item.name)) {
                Text(item.name) // 목록 항목을 표시
            }
        }
        .navigationTitle("목록 화면") // 네비게이션 바의 제목
    }
    
    func updateDocumentList() {
//        documentList.
    }
}
