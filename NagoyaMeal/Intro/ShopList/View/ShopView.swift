//
//  ShopView.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/10/31.
//

import SwiftUI

struct ShopView: View {
    let currentUser: String
    @StateObject private var svm = ShopViewModel()
    //一覧とマップの表示を切り替え
    @State private var selectedTab: Tab?
    @State private var tabProgress: CGFloat = 0
    
    @Environment(\.dismiss) private var dismiss
    
    @State var isGenre = false
    @State var isSort = false
    @State var isOpen = false
    @State var isSheet = false
    
    @ObservedObject var gvm: GenreViewModel
    
    @State private var sortLists: [String] = ["登録順","口コミ順","人気順","評価順","お店名順"]
    
    var body: some View {
        ZStack{
            //背景色
            Color.baseBg
                .ignoresSafeArea()
            
            VStack (spacing: 0){
                NavigationBackButton(){
                    isSheet = false
                    dismiss()
                }
                
                VStack {
                    ShopListHeader().padding(.horizontal)
                    
                    ShopFilterItem(isGenre: $isGenre, isSort: $isSort, isOpen: $isOpen, gvm: gvm, svm: svm, isSheet: $isSheet).padding(.bottom)
                }.padding(.top)
                    .overlay(Rectangle().frame(height: 1).foregroundStyle(.gray), alignment: .bottom)
                
                
                
                GeometryReader{
                    let size = $0.size
                    
                    ScrollView(.horizontal){
                        LazyHStack(spacing: 0){
                            ShopListCells(gvm: gvm, svm: svm, currentUser: currentUser)
                                .id(Tab.lists)
                                .containerRelativeFrame(.horizontal)
                            ShopMapView(gvm: gvm, svm: svm, currentUser: currentUser, isSheet: $isSheet)
                                .id(Tab.maps)
                                .containerRelativeFrame(.horizontal)
                        }
                        .scrollTargetLayout()
                        .offsetX{ value in
                            _ = -value / (size.width * CGFloat(Tab.allCases.count - 1))
                        }
                    }
                    .scrollPosition(id: $selectedTab)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.paging)
                    .scrollClipDisabled()
                    
                }
            } .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(.gray.opacity(0.1))
            
            
            
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $isGenre, onDismiss: {
            if let selectGenreId = gvm.getGenreId(){
                Task{
                    let sortKey = svm.getSortKey(from: svm.selectSort)
                    
                    await svm.fetchShops(genreId: selectGenreId, sortKey: sortKey)
                    await svm.fetchFavorites(userId: currentUser)
                    
                    svm.convertToFavoriteShops()
                    
                    await svm.fetchFavoritesShops()
                    
                    
                    
                }
            }

        }){
            
            GenrePicker(genreLists: gvm.genres, gvm: gvm)
                .presentationDetents([
                    .fraction(0.4)
                ])
            
        }
        .sheet(isPresented: $isSort, onDismiss: {
            if let selectGenreId = gvm.getGenreId(){
                Task{
                    let sortKey = svm.getSortKey(from: svm.selectSort)
                    
                    await svm.fetchShops(genreId: selectGenreId, sortKey: sortKey)
                    await svm.fetchFavorites(userId: currentUser)
                    
                    svm.convertToFavoriteShops()
                    
                    await svm.fetchFavoritesShops()
                    
                    
                    
                }
            }

        }){
            SortPicker(sortLists: sortLists, sort: $svm.selectSort)
                .presentationDetents([
                    .fraction(0.4)
                ])
            
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
    
    //Header(一覧とmap表示の切り替え)
    @ViewBuilder
    func ShopListHeader() -> some View {
        HStack{
            Spacer()
            ForEach(Tab.allCases, id: \.rawValue){ tab in
                HStack(spacing: 10){
                    Image(systemName: tab.systemImg)
                    Text(tab.rawValue)
                        .font(.callout)
                }
                
                .padding(.vertical, 10)
                .contentShape(.capsule)
                .onTapGesture {
                    withAnimation(.snappy){
                        isSheet = false
                        selectedTab = tab
                    }
                }
                Spacer()
            }
        }
        .background{
            GeometryReader{
                let size = $0.size
                let capSize = size.width / CGFloat(Tab.allCases.count)
                let selectedIndex = Tab.allCases.firstIndex(of: selectedTab ?? .lists) ?? 0
                let offsetX = CGFloat(selectedIndex) * capSize
                
                Capsule()
                    .fill(.accent)
                    .frame(width: capSize)
                    .offset(x: offsetX)
            }
        }
        .background(.accent.opacity(0.4), in: .capsule)
        .padding(.horizontal, 5)
    }
    
    
    
}

#Preview {
    ShopView(currentUser: "00779ab7e49b4fcebe61aed9a4827b92", gvm: GenreViewModel())
}
