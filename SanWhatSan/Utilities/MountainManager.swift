//
//  MountainManager.swift
//  SanWhatSan
//
//  Created by 박난 on 7/17/25.
//

import CoreLocation

import Foundation
import CoreLocation
import MapKit

final class MountainManager: ObservableObject {
    
    static let shared = MountainManager()
    private(set) var mountains: [Mountain] = []
    private var mountainNames: [String] = []    //MARK: 산 이름만 넣어도 될 것 같아요
    
    @Published var chosenMountain: Mountain?

    private init() {
        self.mountains = [
            Mountain(name: "운제산", description: "경북", coordinate: Coordinate(latitude: 35.8401, longitude: 128.5554)),
            Mountain(name: "도음산", description: "경북", coordinate: Coordinate(latitude: 35.8725, longitude: 128.6021)),
            Mountain(name: "봉좌산", description: "경북", coordinate: Coordinate(latitude: 35.8602, longitude: 128.5703))
        ]
        self.mountainNames = [
            "운제산", "도음산", "봉좌산"
        ]
    }
    
    // MARK: -산 이름으로 위경도 검색해서 배열로 반환
    func searchMountains (names: [String], regionCenter: CLLocationCoordinate2D, radius: CLLocationDistance){
        mountains.removeAll()
        let group = DispatchGroup()
        
        for name in names {
            group.enter()
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = name
            request.region = MKCoordinateRegion(center: regionCenter, latitudinalMeters: radius, longitudinalMeters: radius)
            
            MKLocalSearch(request: request).start { response, error in
                defer { group.leave() }
                guard let items = response?.mapItems.first,
                      let title = items.name else { print("검색 실패"); return }
                
                let street = items.placemark.thoroughfare ?? ""
                let number = items.placemark.subThoroughfare ?? ""
                let city = items.placemark.locality ?? ""
                let admin = items.placemark.administrativeArea ?? ""
               
                let address = [admin, city, street + number]
                    .filter { !$0.isEmpty }
                    .joined(separator: " ")
                print(address)  // 삭제
                let coord = items.placemark.coordinate
                let mountain = Mountain(name: title, description: address, coordinate:Coordinate(latitude: coord.latitude, longitude: coord.longitude))
                DispatchQueue.main.async{
                    self.mountains.append(mountain)
                }
            }
        }
        
        group.notify(queue: .main) {
            print("진짜 검색 완료: \(self.mountains.map(\.name))" )
        }
    }
    

    func getClosestMountains(from location: CLLocation, within radius: Double = 100_000) -> [Mountain] {
        mountains.compactMap { mountain in
            let distance = CLLocation(
                latitude: mountain.coordinate.latitude,
                longitude: mountain.coordinate.longitude
            ).distance(from: location)

            return distance <= radius ? (mountain, distance) : nil
        }
        .sorted { $0.1 < $1.1 }
        .map { $0.0 }
    }

    func distance(from location: CLLocation, to mountain: Mountain) -> CLLocationDistance {
        CLLocation(
            latitude: mountain.coordinate.latitude,
            longitude: mountain.coordinate.longitude
        ).distance(from: location)
    }
}

