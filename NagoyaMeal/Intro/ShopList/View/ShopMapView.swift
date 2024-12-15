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
            MapView(gvm: gvm, svm: svm, currentUser: currentUser)
            
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
        .onAppear{
            if let selectGenreId = gvm.getGenreId(){
                Task{
                    let sortKey = svm.getSortKey(from: svm.selectSort)
                    
                    await svm.fetchShops(genreId: selectGenreId, sortKey: sortKey)
                    await svm.fetchFavorites(userId: currentUser)
                    
                    svm.convertToFavoriteShops()
                    
                    await svm.fetchFavoritesShops()

                }
            }
        }
    }
}

#Preview {
    //ShopMapView(gvm: GenreViewModel(), svm: ShopViewModel(), currentUser: "test2")
}
