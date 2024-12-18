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
    @Binding var isSheet: Bool
    @Binding var isShopDetail: Bool
    
    @StateObject var locationManager = LocationManager()
    @StateObject var mapvm = MapViewModel()
    @State private var userCameraPosition: MapCameraPosition = .userLocation(followsHeading: true,
                                                                             fallback: .camera(MapCamera(centerCoordinate: .nagoyaStation,
                                                                                                         distance: 5000,
                                                                                                         pitch: 0)))
    @Binding var selectedMarker: MapShop?
    
    
    var body: some View {
        Map(position: $userCameraPosition, selection: $selectedMarker) {
            UserAnnotation(anchor: .center)
            ForEach(mapvm.mapShops) { shop in
                Marker(coordinate: CLLocationCoordinate2D(latitude: shop.lat, longitude: shop.long)) {
                    Text(shop.name)
                    Image(systemName: "fork.knife")
                }
                .tint(Color.accent)
                .tag(shop)
                
            }
        }
        .task() {
            locationManager.requestLocationAuthorization()
        }
        .mapControls {
            MapUserLocationButton()
            MapPitchToggle()
            MapScaleView()
        }
        .onAppear {
            mapvm.geocoding(shops: svm.shops)
            
        }
        .onChange(of: svm.shops) {
            mapvm.geocoding(shops: svm.shops)
        }
        .onChange(of: userCameraPosition, { oldValue, newValue in
            svm.selectShop = nil
        })
        .onChange(of: svm.selectShop) {
            if let checkshop = svm.selectShop{
                Task{
                    if let selectMapShop = await mapvm.selectGeocoding(shop: checkshop){
                        withAnimation {
                            userCameraPosition = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: selectMapShop.lat - 0.003, longitude: selectMapShop.long), distance: 5000, pitch: 0))
                        }
                    }
                }
            }
        }
        .onChange(of: selectedMarker){
            
            if let selectedMarker{
                isSheet = false
                svm.selectShop = svm.favoritesShops.first(where: { $0.id == selectedMarker.id })
                isShopDetail = true
            }
            
            
        }
    }
}



//#Preview {
//    MapView()
//}

