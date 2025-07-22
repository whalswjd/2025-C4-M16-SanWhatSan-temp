//
//  MountainListView.swift
//  SanWhatSan
//
//  Created by Zhen on 7/7/25.
//

import SwiftUI
import MapKit

struct MountainListView: View {
    
//    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @StateObject private var viewModel = MountainListViewModel()
//    @Binding var chosenMountain: Mountain?    //binding 변경
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.85, longitude: 128.57),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    
    //지도중심 따라다니는거 ~
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    
    var body: some View {
            VStack{
                // 이거는 원래 카메라뷰에 들어가야 할 내용인디 일단 이 뷰에다가 할게용 !
                if let selected = viewModel.selectedMountain {
                    Text("선택한 산: \(selected.name)")
                        .font(.headline)
                        .padding(.top)

                    Map(position: $cameraPosition) {
                        Marker(selected.name, coordinate: selected.coordinate.clLocationCoordinate2D)
                    }
                    .cornerRadius(20)
                    .frame(height: 300)
                    .padding(.bottom)
                } else {
                    Text("선택된 산 없음")
                        .font(.headline)
                        .padding(.top)
                }
                //
                if viewModel.closestMountains.isEmpty {
                    Text("주변 100km 이내에 산이 없습니다 🏞️")
                        .font(.headline)
                        .padding()
                }
                else{
                    ForEach(viewModel.closestMountains) { mountain in
                        MountainStackCardView(
                            title: mountain.name,
                            description: "위도: \(mountain.coordinate.latitude), 경도: \(mountain.coordinate.longitude)"
                        ) {
//                            chosenMountain = mountain
//                            dismiss()
                            viewModel.manager.chosenMountain = mountain
                            coordinator.pop()
                        }
                    }
                }
                
            }
            .onAppear{
               // viewModel.requestLocationAccess()
                
            }
            .onChange(of: viewModel.closestMountains) {
                if let first = viewModel.closestMountains.first {
                    cameraPosition = .region(MKCoordinateRegion(
                        center: first.coordinate.clLocationCoordinate2D,
                        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                    ))
                }
            }
//            .onChange(of: chosenMountain) {
//                if let selected = chosenMountain {
//                        withAnimation {
//                            cameraPosition = .region(
//                                MKCoordinateRegion(
//                                    center: selected.coordinate.clLocationCoordinate2D,
//                                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
//                                )
//                            )
//                        }
//                    }
//            }
            .alert("위치 권한이 필요합니다", isPresented: $viewModel.shouldShowAlert){
                Button("OK", role: .cancel){}
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
    }



#Preview {
    MountainListView()
}
