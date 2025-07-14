//
//  CameraViewModel.swift
//  SanWhatSan
//
//  Created by 박난 on 7/10/25.
//

import SwiftUI

class CameraViewModel: ObservableObject {
    
    let arManager = ARManager()
    
    func startARSession() {
        arManager.startSession()
    }

    func handleTap(at point: CGPoint) {
        arManager.placeModel(at: point)
        print("placeModel")
    }
}
