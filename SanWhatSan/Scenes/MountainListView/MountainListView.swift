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
                // MARK: 상단 바
                HStack {
                    
                    //MARK: 뒤로가기
                    Button(action: {
                        coordinator.pop()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .padding(.leading, 16)
                    Spacer()
                    //MARK: 현재 선택된 산은 ~
                    HStack(spacing:8){
                        ZStack{
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: .init(colors: [Color.accentColor.opacity(0.8), Color.accentColor.opacity(0.3)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "mountain.2.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 23, height: 23)
                                .foregroundColor(.white)
                        }
                        if let selected = viewModel.selectedMountain {
                            Text("현재 선택된 산은")
                                .font(.headline)
                                .foregroundColor(.neutrals2)
                            Text("\(selected.name)")
                                .font(.headline)
                        }
                        else{
                            Text("선택된 산 없음")
                                .font(.headline)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(20)
                    .fixedSize()
                    Spacer()
                    Spacer()

                }
                Spacer()
                Spacer()
                Spacer()
                
                //MARK: ListCardView
                //TODO: Modifying state during view update, this will cause undefined behavior. 스택 카드 뷰 수정
                VStack(spacing: 10){
                    if viewModel.closestMountains.isEmpty {
                        Text("주변 100km 이내에 산이 없습니다 🏞️")
                            .font(.headline)
                            .background(Color.white)
                            .cornerRadius(15)
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
        .navigationBarBackButtonHidden(true)
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
        //        .padding(.horizontal)
        //        .padding(.vertical)
        
    }
}


