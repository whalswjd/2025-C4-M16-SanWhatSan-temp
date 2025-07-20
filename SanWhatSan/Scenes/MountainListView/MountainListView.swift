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
        center: .init(latitude: 36.0, longitude: 128.0),
        latitudinalMeters: 10_000,
        longitudinalMeters: 10_000
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
                    //                    Map(
                    //                        coordinateRegion: $region,
                    //                        interactionModes: .all,
                    //                        showsUserLocation: true,
                    //                        userTrackingMode: .constant(.none)
                    //                        //userTrackingMode: .constant(.follow),
                    //                        //annotationItems: viewModel.closestMountains
                    //                    ) {
                    //                        // 선택된 산
                    //                        if let selected = viewModel.selectedMountain {
                    //                            Marker(
                    //                                selected.name,
                    //                                coordinate: selected.coordinate.clLocationCoordinate2D
                    //                            )
                    //                        }
                    //                        // 모든 가까운 산
                    //                        ForEach(viewModel.closestMountains) { mountain in
                    //                            MapAnnotation(coordinate: mountain.coordinate.clLocationCoordinate2D) {
                    //                                MountainMapAnnotationView(mountain: mountain)
                    //                            }
                    //                        }
                    //                    }
                    //                }
//                    Map(
//                        coordinateRegion: $region,
//                        interactionModes: .all,
//                        showsUserLocation: true,
//                        userTrackingMode: .constant(.none),
//                        annotationItems: viewModel.closestMountains
//                    ) { mountain in
//                        MapAnnotation(coordinate: mountain.coordinate.clLocationCoordinate2D) {
//                                MountainMapAnnotationView(
//                                    mountain: mountain,
//                                    isSelected: mountain.id == viewModel.selectedMountain?.id
//                                )
//                            }
//                    }
//                    .frame(height: 300)
//                    .cornerRadius(20)
//                    .padding(.bottom)
                    MountainMapView(region: $region,
                                    mountains: viewModel.closestMountains)
                    .padding()
                    
                }
                
                else {
                    Text("선택된 산 없음")
                        .font(.headline)
                        .padding(.top)
                }
                
                //MARK: ListCardView
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
            //MARK: 0.5 = 500 km (임시)
            .onChange(of: viewModel.closestMountains) { newList in
                if let first = newList.first {
                    withAnimation {
                        region = MKCoordinateRegion(
                            center: first.coordinate.clLocationCoordinate2D,
                            span: MKCoordinateSpan(latitudeDelta: 0.5,
                                                   longitudeDelta: 0.5)
                        )
                    }
                }
            }
//            .onChange(of: viewModel.closestMountains) {
//                if let first = viewModel.closestMountains.first {
////                    cameraPosition = .region(MKCoordinateRegion(
////                        center: first.coordinate.clLocationCoordinate2D,
////                        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
////                    ))
//                }
//            }
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


