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
    
    var body: some View {
        Text("MountainListView")
        NavigationStack{
            VStack{
                
                Map()
                    .cornerRadius(20)
                    .padding(.vertical)
                MountainStackCardView(title: "운제산",description: "산1"){
                    dismiss()
                }
                MountainStackCardView(title: "운제산",description: "산2"){
                    dismiss()
                }
                MountainStackCardView(title: "운제산",description: "산2"){
                    dismiss()
                }

            }
            .padding(.horizontal)
            .padding(.vertical)
        }
    }
}


#Preview {
    MountainListView()
}
