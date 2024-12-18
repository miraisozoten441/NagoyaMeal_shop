//
//  GenreListView.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/10/25.
//

import SwiftUI

struct GenreListView: View {
    
    @EnvironmentObject var env: EnvironmentsSettings
    @StateObject private var gvm = GenreViewModel()
    
    @State var genreId = ""
    
    @State var currentUser = "test1"
    
    var body: some View {
        NavigationStack {
            ZStack{
                //背景設定
                Color.baseBg
                    .ignoresSafeArea()
                
                
                ScrollView(.vertical, showsIndicators: false){
                    //ここはできたら作成
                    //                    LazyVGrid(columns: Array(repeating: GridItem(), count: 1), content: {
                    //                        NavigationLink(destination: a()){
                    //                            //サイズなどを渡す
                    //                            GenreListCell(color: .accent, h: 200, GenerName: "おすすめ")
                    //                        }
                    //
                    //                    })
                    Spacer().frame(height: 30)
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 3), content: {
                        ForEach(gvm.genres.filter { $0.id != "0" }){ list in
                            
                            NavigationLink(destination: ShopView(currentUser: currentUser, gvm: gvm)){
                                GenreListCell(color: .accent, h: 100, GenerName: list.genre_name)
                                
                            }
                            .simultaneousGesture(
                                TapGesture().onEnded {
                                    gvm.selectGenre = list.genre_name
                                }
                            )
                        }
                    })
                    Spacer().frame(height: 200)
                }.padding(10)
            }.ignoresSafeArea(edges: Edge.Set.bottom)
        }
        
        
    }
}

struct a: View {
    var body: some View {
        Text("a")
    }
}

#Preview {
    GenreListView().environmentObject(EnvironmentsSettings())
}
