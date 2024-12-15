////
////  MapView.swift
////  NagoyaMeal
////
////  Created by 中島瑠斗 on 2024/11/22.
////
//
import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var gvm: GenreViewModel
    @ObservedObject var svm: ShopViewModel
    let currentUser: String
    
    
    @StateObject var locationManager = LocationManager()
    @StateObject var mapvm = MapViewModel()
    @State private var userCameraPosition: MapCameraPosition = .userLocation(followsHeading: true,
                                                                             fallback: .camera(MapCamera(centerCoordinate: .nagoyaStation,
                                                                                                             distance: 5000,
                                                                                                             pitch: 0)))
    
    var body: some View {
        
        
        
        Map(position: $userCameraPosition, interactionModes: .all) {
            UserAnnotation(anchor: .center)
            ForEach(mapvm.mapShops) { shop in
                Marker(coordinate: CLLocationCoordinate2D(latitude: shop.lat, longitude: shop.long)) {
                    Text(shop.name)
                    Image(systemName: "fork.knife")
                }
                .tint(Color.accent)
            }
            
            
        }
        .task() {
            locationManager.requestLocationAuthorization()
        }
        .mapControls {
            MapUserLocationButton()
        }
        .onAppear {
            mapvm.geocoding(shops: svm.shops)

        }
        .onChange(of: svm.shops) {
            mapvm.geocoding(shops: svm.shops)
        }
    }
}



//#Preview {
//    MapView()
//}

