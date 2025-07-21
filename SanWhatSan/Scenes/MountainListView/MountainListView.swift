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
    @State private var region = MKCoordinateRegion(
        center: .init(latitude: 36.0, longitude: 128.0),
        latitudinalMeters: 10_000,
        longitudinalMeters: 10_000
    )
    
    
    var body: some View {
        
        ZStack{
            //MARK: 지도
            MountainMapView(region: $region,
                            mountains: viewModel.closestMountains)
            .ignoresSafeArea(.all)
            VStack{
                HStack{
                    
                    Image(systemName: "mountain.2.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 27, height: 27)
                        .foregroundColor(.accent)
                    
                    // MARK: 선택한 산 (header)
                    if let selected = viewModel.selectedMountain {
                        Text("선택한 산: \(selected.name)")
                            .font(.headline)
                            .padding(.top)
                    }
                    
                    else {
                        Text("선택된 산 없음")
                            .font(.headline)
                            .padding(.top)
                    }
                }
                
                
                //MARK: ListCardView
                //TODO: Modifying state during view update, this will cause undefined behavior. 스택 카드 뷰 수정
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
}


