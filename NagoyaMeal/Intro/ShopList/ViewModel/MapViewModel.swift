//
//  MapViewModel.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/12/05.
//

import SwiftUI
import MapKit

class MapViewModel: ObservableObject {
    @Published var mapShops: [MapShop] = []
    
    ///取得しているshopsからアドレスを緯度経度に直して新しい配列に格納
    func geocoding(shops: [Shops]) {
        self.mapShops = []
        for shop in shops{
            let address = shop.shop_address
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { (placemarks, error) in
                guard let lat = placemarks?.first?.location?.coordinate.latitude else { return }
                guard let long = placemarks?.first?.location?.coordinate.longitude else { return }
                let newMapShop = MapShop(id: shop.id, name: shop.shop_name, lat: lat, long: long)
                self.mapShops.append(newMapShop)
            }
        }
        
    }
    
}

struct MapShop: Codable, Identifiable {
    let id: String
    let name: String
    let lat: Double
    let long: Double
}
