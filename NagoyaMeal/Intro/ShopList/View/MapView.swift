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
    
    let locationManager = LocationManager()
    
    var body: some View {
        Map(interactionModes: .all) {
//            UserAnnotation(anchor: .center) { userLocation in
//                VStack {
//                    
//                    Circle()
//                        .foregroundStyle(.blue)
//                        .padding(2)
//                        .background(
//                            Circle()
//                                .fill(.white)
//                        )
//                    Text("me")
//                }
//            }
            UserAnnotation()
        }
        .mapControls {
            MapUserLocationButton()
        }
        .onAppear {
            locationManager.requestLocationAuthorization()
        }
    }
}



#Preview {
    MapView()
}

