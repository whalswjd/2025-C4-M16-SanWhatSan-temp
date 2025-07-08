//
//  LocationAuth.swift
//  SanWhatSan
//
//  Created by Zhen on 7/8/25.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var lastLocation: CLLocation?
    @Published var shoudShowAlert = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkAuthorizationStatus() {
        let status = locationManager.authorizationStatus
        handleAuthorizationStatus(status)
    }
    
    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
        }
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            // 그냥 돌리니까 Modifying state during view update, this will cause undefined behavior. 에러
            DispatchQueue.main.async {
                    DispatchQueue.main.async {  // ㅇㅏㄴㅣ 왜 ?
                        self.shoudShowAlert = true
                    }
                }
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("권한 상태 변경: \(manager.authorizationStatus.rawValue)")
        handleAuthorizationStatus(manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            print("위치 갱신: \(locations)")
            self.lastLocation = locations.last
        }
    }
    
}


