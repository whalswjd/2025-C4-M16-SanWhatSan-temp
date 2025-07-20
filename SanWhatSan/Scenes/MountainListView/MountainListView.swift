//
//  MountainListView.swift
//  SanWhatSan
//
//  Created by Zhen on 7/7/25.
//

import SwiftUI
import MapKit

struct MountainListView: View {
    
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @StateObject private var viewModel = MountainListViewModel()
    // MARK: 지도 이동 (userLocation)
//    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 36.0, longitude: 128.0),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    
    var body: some View {
            VStack{
                // MARK: 선택한 산 (header)
                if let selected = viewModel.selectedMountain {
                    Text("선택한 산: \(selected.name)")
                        .font(.headline)
                        .padding(.top)

//                    Map(position: $cameraPosition) {
//                        Marker(selected.name, coordinate: selected.coordinate.clLocationCoordinate2D)
//                    }
                    Map(
                        coordinateRegion: $region,
                        interactionModes: .all,
                        showsUserLocation: true,
                        userTrackingMode: .constant(.follow),
                        annotationItems: viewModel.closestMountains
                    ) { mountain in
                        MapMarker(
                            coordinate: mountain.coordinate.clLocationCoordinate2D,
                            tint: .green
                        )
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
                    VStack{
                        Text("주변 100km 이내에 산이 없습니다 🏞️")
                            .font(.headline)
                            .padding()
                    }
                    
                }

                else{
                    ForEach(viewModel.closestMountains) { mountain in
                        MountainStackCardView(
                            title: mountain.name,
                            description: "위도: \(mountain.coordinate.latitude), 경도: \(mountain.coordinate.longitude)"
                        ) {
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
//                    cameraPosition = .region(MKCoordinateRegion(
//                        center: first.coordinate.clLocationCoordinate2D,
//                        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
//                    ))
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
        //MARK: custom Alert
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
