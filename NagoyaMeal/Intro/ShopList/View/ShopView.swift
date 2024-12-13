//
//  ShopView.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/10/31.
//

import SwiftUI

struct ShopView: View {
    
    let genreId: String
    let currentUser: String
    @StateObject private var svm: ShopViewModel
    @StateObject private var fvm = FavoriteViewModel()
    //一覧とマップの表示を切り替え
    @State private var selectedTab: Tab?
    @State private var tabProgress: CGFloat = 0
    
    @Environment(\.dismiss) private var dismiss
    
    @State var isGenre = false
    @State var isSort = false
    @State var isOpen = false
    @State var selectGenre: String = ""
    @State var selectSort: String = "人気順"
    
    let genreLists: [Genres]
    
    @State private var sortLists: [String] = ["口コミ順","人気順","評価順","お値段順","お店名順"]
    
    
    init(genreId: String, currentUser: String, genreLists: [Genres]) {
        self.genreId = genreId
        self.currentUser = currentUser
        self.genreLists = genreLists
        _svm = StateObject(wrappedValue: ShopViewModel(genreId: genreId, userId: currentUser))
    }
    
    
    var body: some View {
        ZStack{
//            let _ = print("-------------------")
//            let _ = print(svm.shops)
//            let _ = print(svm.favoritesShops)
            //背景色
            Color.baseBg
                .ignoresSafeArea()
            
            VStack (spacing: 0){
                NavigationBackButton(){
                    dismiss()
                }
                
                VStack {
                    ShopListHeader().padding(.horizontal)
                    
                    ShopFilterItem(isGenre: $isGenre, isSort: $isSort, isOpen: $isOpen, selectGenre: $selectGenre, selectSort: $selectSort).padding(.bottom)
                }.padding(.top)
                    .overlay(Rectangle().frame(height: 1).foregroundStyle(.gray), alignment: .bottom)
                
                
                
                GeometryReader{
                    let size = $0.size
                    
                    ScrollView(.horizontal){
                        LazyHStack(spacing: 0){
                            ShopListCells(svm: svm, currentUser: currentUser)
                                .id(Tab.lists)
                                .containerRelativeFrame(.horizontal)
                            ShopMapView(shopList: svm.shops)
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
        .sheet(isPresented: $isGenre){
            
            GenrePicker(genreLists: genreLists, select: $selectGenre)
                .presentationDetents([
                    .fraction(0.4)
                ])
            
        }
        .sheet(isPresented: $isSort){
            
            SortPicker(genreLists: sortLists, select: $selectSort)
                .presentationDetents([
                    .fraction(0.4)
                ])
            
        }
        .onAppear{
            Task{ await svm.fetchFavoritesShops(shops: svm.shops)}
            selectGenre = genreLists.first(where: { $0.id == genreId })?.genre_name ?? ""
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
    ShopView(genreId: "1", currentUser: "00779ab7e49b4fcebe61aed9a4827b92", genreLists: Genres.MOCK_GENRE)
}
