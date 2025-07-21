//
//  Route.swift
//  SanWhatSan
//
//  Created by 박난 on 7/10/25.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case cameraView
//    case imageView(DisplayImage)
    case mountainListView
    case albumView
    case photoDetailView(DisplayImage)
//    case frameView    // TODO: 나중에 추가하면 주석 해제하기
}
