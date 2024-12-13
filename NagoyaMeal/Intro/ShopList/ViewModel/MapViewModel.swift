//
//  MapViewModel.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/12/05.
//

//import SwiftUI
//import Combine
//import CoreLocation
//
//class MapViewModel: ObservableObject {
//    @Published var userLocations: [MatchingLocation] = []
//    @Published var targetLocation: CLLocationCoordinate2D?
//    private var cancellables = Set<AnyCancellable>()
//    
//    func fetchUserLocations(for userId: String) async {
//        do {
//            // APIリクエスト
//            self.userLocations = try await APIRequests().getUserLocations(for: userId)
//        } catch {
//            print("Failed to fetch locations: \(error)")
//        }
//    }
//}
