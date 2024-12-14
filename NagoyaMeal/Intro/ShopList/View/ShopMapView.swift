//
//  ShopMapView.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/10/31.
//

import SwiftUI
import MapKit

struct ShopMapView: View {
    
    @ObservedObject var gvm: GenreViewModel
    @ObservedObject var svm: ShopViewModel
    let currentUser: String
    @Binding var isSheet: Bool
    
    
    
    var body: some View {
        VStack {
            
            Map()
            
            Spacer()
            
            if !isSheet {
                HStack{
                    Button("リストを表示"){
                        isSheet.toggle()
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 3)
            }
            
        }.sheet(isPresented: $isSheet){
            VStack{
                Text("")
                ShopMapCells(gvm: gvm, svm: svm, currentUser: currentUser, isSheet: $isSheet)
                
            }
            .presentationDetents([
                .fraction(0.96),
                .fraction(0.4),
            ])
            .presentationBackgroundInteraction(.enabled)
        }
    }
}

#Preview {
    //ShopMapView(gvm: GenreViewModel(), svm: ShopViewModel(), currentUser: "test2")
}
