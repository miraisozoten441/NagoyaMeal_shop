//
//  ShopMapView.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/10/31.
//

import SwiftUI
import MapKit

struct ShopMapView: View {
    
    let shopList: [Shops]
    @State private var isSheet = false
    
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
                ShopMapCells(shopList: shopList)
                
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
    ShopMapView(shopList: Shops.MOCK_SHOP)
}
