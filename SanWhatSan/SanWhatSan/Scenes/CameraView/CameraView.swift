//
//  CameraView.swift
//  SanWhatSan
//
//  Created by Zhen on 7/7/25.
//

import SwiftUI

struct CameraView: View {
    var body: some View {
        
        
        
        NavigationStack{
            VStack{
                
                Text("CameraView").font(.title)
                    .padding(20)
                
                
                NavigationLink{
                    MountainListView()
                } label: {
                    Text("다른 산으로 이동")
                        .padding(10)
                }

                NavigationLink{
                    ImageView()
                } label: {
                    Text("이미지뷰로 이동")
                        .padding(10)
                }
                
               
            }
        }
    }
}

#Preview {
    CameraView()
}
