//
//  MountainListView.swift
//  SanWhatSan
//
//  Created by Zhen on 7/7/25.
//

import SwiftUI
import MapKit

struct MountainListView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = MountainListViewModel()
    
    let mountains: [Mountain] = [
            Mountain(name: "운제산", description: "경북 경산", coordinate: CLLocationCoordinate2D(latitude: 35.8401, longitude: 128.7781)),
            Mountain(name: "도음산", description: "경북 경산", coordinate: CLLocationCoordinate2D(latitude: 35.8322, longitude: 128.7993)),
            Mountain(name: "봉좌산", description: "경북 경산", coordinate: CLLocationCoordinate2D(latitude: 35.8498, longitude: 128.7412))
        ]
    
    // 하드코딩
    
    //산 이름 배열
    
    //그 다음에 현재 위치 가져오고
    
    // 이름 -> 좌표 검색 & 거리 계산
    

    var body: some View {
        NavigationStack{
            VStack{
                
                Map()
                    .cornerRadius(20)
                    .padding(.vertical)
                    .frame(height: 300)
                
                ForEach(mountains) { mountain in
                    MountainStackCardView(title: mountain.name,description: mountain.description) {
                        dismiss()
                    }
                }

            }
            .padding(.horizontal)
            .padding(.vertical)
        }
        .navigationTitle("MountainListView")
    }
}


#Preview {
    MountainListView()
}
