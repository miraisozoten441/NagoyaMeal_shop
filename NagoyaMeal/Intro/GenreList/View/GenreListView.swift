//
//  GenreListView.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/10/25.
//

import SwiftUI

struct GenreListView: View {
    
    @StateObject private var gvm = GenreViewModel()
    
    @State var genreId = ""
    
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
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 3), content: {
                        ForEach(gvm.genres){ list in
                            
                            NavigationLink(destination: ShopView(genreId: list.id, currentUser: "00779ab7e49b4fcebe61aed9a4827b92", genreLists: gvm.genres)){
                                GenreListCell(color: .accent, h: 100, GenerName: list.genre_name)
                                
                            }
                        }
                    })
                }
                
                .padding(10)
                
                
                
                
            }
        }
        
        
    }
}

struct a: View {
    var body: some View {
        Text("a")
    }
}

#Preview {
    GenreListView()
}
