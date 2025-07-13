//
//  AppNavigationView.swift
//  SanWhatSan
//
//  Created by 박난 on 7/10/25.
//

// TODO: 바인딩 변수 고려해서 리팩토링 해야함 혹은 navigationDestination 쓰지 않고 구현
//import SwiftUI
//
//struct AppNavigationView: View {
//    @StateObject var coordinator = NavigationCoordinator()
//    
//    var body: some View {
//        NavigationStack(path: $coordinator.path){
//            CameraView()
//                .navigationDestination(for: Route.self) { route in
//                    switch route {
//                    case .cameraView:
//                        CameraView()
//                    case .imageView(let image):
//                        ImageView(image: image)
//                    case .mountainListView():
//                        MountainListView()
//                    }
//                }
//        }
//    }
//}
