//
//  Component.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/10/25.
//

import SwiftUI

//お店までの経路、電話などのボタン
struct CustomButtonShopUnder: View {
    let title: String
    let systemName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemName)
                    .font(.subheadline)
                
                Text(title)
                    .font(.headline)
                
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(.mainBg)
            .cornerRadius(30)
        }
    }
}

//Mapのcell
struct MapSheetCell: View {
    
    let genre: String
    
    let shopName: String
    let review: Float
    let distance: Int
    let status: Bool
    let openingTimes: String
    @State var isFavorite = false
    
    var body: some View{
        HStack{
            
            VStack{
                VStack{
                    HStack{
                        Text(genre)
                            .frame(width: 100)
                            .foregroundStyle(.white)
                            .background(.mainBg)
                        
                        Spacer()
                    }
                    
                    //お店の名前
                    HStack{
                        Text(shopName)
                        
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Button{
                            isFavorite.toggle()
                        } label: {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.title)
                                .foregroundStyle(isFavorite ? .pink : .primary)
                        }
                        .padding(.horizontal)
                        
                    }
                    .font(.title3)
                    //評価 & 距離
                    HStack{
                        Text(String(format: "%.1f", review))
                        StarRating(rating: review)
                        Text("・")
                        //距離
                        Text("\(distance)m")
                        Spacer()
                        
                    }
                    
                    //営業状態
                    HStack{
                        Text(status ? "営業中": "休業中")
                            .lineLimit(1)
                        Text(openingTimes)
                        Spacer()
                    }
                    
                }
                .padding(.leading)
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        Text("")
                        
                        CustomButtonShopUnder(title: "徒歩", systemName: "figure.walk"){
                            print("徒歩")
                        }
                        CustomButtonShopUnder(title: "自動車", systemName: "car.fill"){
                            print("車")
                        }
                        CustomButtonShopUnder(title: "電話", systemName: "phone.fill"){
                            print("電話")
                        }
                        CustomButtonShopUnder(title: "共有", systemName: "square.and.arrow.up"){
                            print("共有")
                        }
                        //                        CustomButtonShopUnder(title: "保存", systemName: "bookmark"){
                        //                            print("保存")
                        //                        }
                        
                    }
                }
                
            }
        }
        .padding(.vertical, 8)
        
    }
    
    
}

//doubleを星で表示
struct StarRating: View {
    
    let rating: Float
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1..<6) { index in
                if Float(index) <= rating {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                } else if rating - Float(index) >= -0.5 {
                    
                    Image(systemName: "star.lefthalf.fill")
                        .foregroundColor(.yellow)
                } else {
                    Image(systemName: "star.fill")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

//GenreListのcell
struct GenreListCell: View {
    let color: Color
    let h: CGFloat
    let GenerName: String
    
    var body: some View {
        Image("\(GenerName)")
            .resizable()
            .scaledToFill()
            .frame(width: h + 20, height: h)
            .cornerRadius(15)
//        Rectangle()
//            .frame(height: h)
//        
            .overlay {
                Color.white
                    .cornerRadius(15)
                    .opacity(0.5)
                VStack(alignment: .center) {
                    Text(GenerName)
                        .foregroundStyle(.black)
                        .shadow(color: .black.opacity(0.5), radius: 0, x: 1, y: 1)
                }
            }
    }
}

//Navigation先のbackボタン
struct NavigationBackButton: View {
    
    let action: () -> Void
    
    var body: some View {
        HStack{
            Button{
                action()
            }label: {
                HStack{
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }
            Spacer()
        }.padding(.horizontal)
    }
}

//口コミ
struct WordOfMouth: View {
    
    let userName: String
    let userReview: Float
    let reviewBody: String
    let date: String
    
    
    var body: some View {
        VStack(alignment: .leading){
            //ユーザー
            HStack{
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .foregroundStyle(Color(.systemGray4))
                
                Text(userName)
                    .font(.subheadline)
                
                Spacer()
                
            }
            
            //評価 & 投稿日
            HStack{
                HStack{
                    Text(String(format: "%.1f", userReview))
                    StarRating(rating: userReview)
                        .foregroundStyle(Color.yellow)
                    Text(date)
                        .font(.caption)
                    
                }
            }
            
            //本文
            HStack{
                Text(reviewBody)
            }
            
            HStack{
                Spacer()
                Button{
                    print("報告")
                }label: {
                    HStack{
                        Text("報告")
                            .font(.title3)
                        Image(systemName: "exclamationmark.triangle.fill")
                    }
                }
                
                
            }
            .padding(.top, 3)
        }
        .padding()
    }
}

//詳細ページのタイトル部分
struct DetailTitle: View {
    let currentUser: String
    
    let shop: FavoriteShops
    let openingTimes: String = "24時間"
    
    @ObservedObject var svm: ShopViewModel
    
    var body: some View{
        HStack{
            
            VStack{
                VStack{
                    
                    HStack{
                        if shop.shop_now_open {
                            Text("営業中")
                                .padding(3)
                                .foregroundStyle(.white)
                                .background(.accent)
                        }
                        
                        ForEach(shop.genres, id: \.id) { genre in
                            Text(genre.genre_name)
                                .padding(3)
                                .foregroundStyle(.white)
                                .background(.mainBg)
                        }
                        
                        Spacer()
                    }
                    //お店の名前
                    HStack{
                        Text(shop.shop_name)
                        
                            .lineLimit(1)
                        
                        Spacer()
                        
                        if shop.isFavorite {
                            Button {
                                delete(shop: shop)
                            } label: {
                                Image(systemName: "heart.fill")
                                    .font(.title)
                                    .foregroundStyle(.pink)
                            }
                            .padding(.horizontal)
                        } else {
                            Button{
                                Task {
                                    try await svm.createFavorites(shopId: shop.id, userId: currentUser) {data in
                                        await MainActor.run {
                                            
                                        }
                                    }
                                    await svm.fetchFavorites(userId: currentUser)
                                    await svm.fetchFavoritesShops()
                                    svm.selectShop?.isFavorite = true
                                    
                                }
                            } label: {
                                Image(systemName: "heart")
                                    .font(.title)
                                    .foregroundStyle(.primary)
                            }
                            .padding(.horizontal)
                        }
                        
                    }
                    .font(.title3)
                    //評価 & 距離
                    HStack{
                        Text(String(format: "%.1f", shop.shop_review))
                        StarRating(rating: shop.shop_review)
                        Spacer()
                        
                    }
                    
                    //営業状態
                    HStack{
//                        Text(openingTimes)
                        Spacer()
                    }
                    
                    //住所
                    HStack{
                        Text("住所:")
                        Text(shop.shop_address)

                        Spacer()
                    }
                    
                    
                }
                
//                ScrollView(.horizontal, showsIndicators: false){
//                    HStack{
//                        Text("")
//                        
//                        CustomButtonShopUnder(title: "徒歩", systemName: "figure.walk"){
//                            print("徒歩")
//                        }
//                        CustomButtonShopUnder(title: "自動車", systemName: "car.fill"){
//                            print("車")
//                        }
//                        CustomButtonShopUnder(title: "電話", systemName: "phone.fill"){
//                            print("電話")
//                        }
//                        CustomButtonShopUnder(title: "共有", systemName: "square.and.arrow.up"){
//                            print("共有")
//                        }
//                    }
//                }
                
            }
        }
        .padding(.vertical, 8)
        .onAppear{
            
        }
        
    }
    
    func delete(shop: FavoriteShops){
        Task {
            if let df = svm.fs.first(where: { $0.shopId == shop.id }) {
                try await svm.deleteFavorites(favoriteId: df.favoriteId) { data in
                    await MainActor.run {
                        print("削除が完了")
                    }
                }
                await svm.fetchFavorites(userId: currentUser)
                await svm.fetchFavoritesShops()
                svm.selectShop?.isFavorite = false
                
                
            } else {
                print("一致するFavoriteShopが見つかりませんでした")
            }
        }
    }
}

//ShopViewのselecter
struct GenrePicker: View {
    
    let genreLists: [Genres]
    @ObservedObject var gvm: GenreViewModel
    @State private var isExpanded = false
    
    var body: some View {
        ZStack{
            
            Color.baseBg
                .ignoresSafeArea()
            
            Picker("ジャンル選択", selection: $gvm.selectGenre) {
                ForEach(genreLists) { genre in
                    Text(genre.genre_name).tag(genre.genre_name)
                }
            }
            .pickerStyle(WheelPickerStyle())
            
            
        }
    }
}

struct SortPicker: View {
    
    let sortLists: [String]
    @Binding var sort: String
    
    var body: some View {
        ZStack{
            
            Color.baseBg
                .ignoresSafeArea()
            
            Picker("ソート選択", selection: $sort) {
                ForEach(sortLists, id: \.self) { list in
                    Text(list)
                }
            }
            .pickerStyle(WheelPickerStyle())
            
            
        }
    }
}


//評価作成時の星
struct CreateRatingView: View {
    
    @Binding var rating: Int
    
    var label = ""
    
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                image(for: number)
                    .font(.largeTitle)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
    
}

/// 共有ボタン
struct ShereButton<T: View>: View {
    
    let label: T
    let item: String
    let message: String
    
    init(item: String, message: String = "Share",
         @ViewBuilder label: () -> T = { Image(systemName: "square.and.arrow.up") }
    ) {
        self.item = item
        self.message = message
        self.label = label()
    }
    
    var body: some View {
        ShareLink(item: item, preview: SharePreview("message")) {
            label
        }
    }
    
}




#Preview {
    //MapSheetCell(genre: "ひつまぶし", nearStation: "名古屋駅", shopName: "ひつまぶし専門店", review: 3.0, distance: 200, status: ["営業中", "準備中", "休業日"], openingTimes: "10:00 ~ 2:00")
    //    NavigationBackButton(){
    //        print("Back")
    //    }
    //DetailPageView()
    
    //    ShereButton(item: "test", message: "message") {
    //           Image(systemName: "square.and.arrow.up")
    //       }
    //DetailPageView()
    //ShopView()
}
