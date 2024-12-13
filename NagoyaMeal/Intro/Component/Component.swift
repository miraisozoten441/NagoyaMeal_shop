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

//shopListのcell
struct ShopListCell: View {
    
    let genre: String
    let distance: Int
    let openingTimes: String
    
    let shop: Shops
    @State var isFavorite = false
    
    @ObservedObject var svm: ShopViewModel
    let currentUser: String
    
    init(genre: String, distance: Int, openingTimes: String, shop: Shops, svm: ShopViewModel, currentUser: String){
        self.genre = genre
        self.distance = distance
        self.openingTimes = openingTimes
        self.shop = shop
        self.svm = svm
        self.currentUser = currentUser
        isFavorite = svm.favoritesShops.contains(where: { $0.shopId == shop.id })
    }

    
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
                        Text(shop.shop_name)
                        
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Button{
                            if(isFavorite){
                                isFavorite = false
                                Task {
                                    if let df = svm.favoritesShops.first(where: { $0.shopId == shop.id }) {
                                        try await svm.deleteFavorites(favoriteId: df.favoriteId) { data in
                                            await MainActor.run {
                                                print("削除が完了")
                                            }
                                        }
                                    } else {
                                        print("一致するFavoriteShopが見つかりませんでした")
                                    }
                                }
                            } else {
                                isFavorite = true
                                Task {
                                    try await svm.createFavorites(shopId: shop.id, userId: currentUser) {data in
                                        await MainActor.run {
                                            
                                        }
                                    }
                                    await svm.fetchFavorites(userId: currentUser)
                                }
                                
                            }
                            
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
                        Text(String(format: "%.1f", shop.shop_review))
                        StarRating(rating: shop.shop_review)
                        Text("・")
                        //距離
                        Text("\(distance)m")
                        Spacer()
                        
                    }
                    
                    //営業状態
                    HStack{
                        Text(shop.shop_now_open ? "営業中": "休業中")
                            .lineLimit(1)
                        Text(openingTimes)
                        Spacer()
                    }
                    
                }
                .padding(.leading)
            }
        }
        .onAppear{
//            isFavorite = fvm.favorites.shop_id == shop.id
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
        Image("ひつまぶし") // アセットに登録されている画像名
            .resizable() // サイズ変更可能にする
            .scaledToFill()
            .frame(height: h) // 高さを指定
            .cornerRadius(15)
        
            .overlay {
                Color.gray
                    .cornerRadius(15)
                    .opacity(0.3) // フィルターの透明度を調整
                
                //                RoundedRectangle(cornerRadius: 15)
                //                    .stroke(.accent, lineWidth: 2)
                VStack(alignment: .center) {
                    Text(GenerName)
                        .foregroundStyle(.white)
                        .shadow(color: .accent, radius: 3, x: 0, y: 0)
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
    
    let genre: String
    
    let shopName: String
    let review: Float
//    let distance: Int
    let status: Bool
    let openingTimes: String
    let address: String
    @State private var isFavorite = false
    
    var body: some View{
        HStack{
            
            VStack{
                VStack{
                    HStack{
                        //ここに営業中やその他のジャンルを表示できるようにする
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
                        Spacer()
//                        Text("・")
                        //距離
//                        Text("\(distance)m")
//                        Spacer()
                        
                    }
                    
                    //営業状態
                    HStack{
                        Text(status ? "営業中": "休業中")
                            .lineLimit(1)
                        Text(openingTimes)
                        Spacer()
                    }
                    
                    //住所
                    HStack{
                        Text("住所:")
                        Text(address)
                            .lineLimit(1)
                        Spacer()
                    }
                    
                }
                
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
                        //                        if isFavorite {
                        //                            CustomButtonShopUnder(title: "保存", systemName: "bookmark"){
                        //                                print("保存")
                        //                            }
                        //                        }else {
                        //                            CustomButtonShopUnder(title: "保存", systemName: "bookmark"){
                        //                                print("保存")
                        //                            }
                        //                        }
                        
                    }
                }
                
            }
        }
        .padding(.vertical, 8)
        
    }
}

//ShopViewのselecter
struct GenrePicker: View {
    
    let genreLists: [Genres]
    @State private var isExpanded = false
    @Binding var select: String
    
    var body: some View {
        ZStack{
            
            Color.baseBg
                .ignoresSafeArea()
            
            VStack{
                VStack{
                    if !isExpanded{
                        HStack(spacing: 10){
                            Text(select)
                            
                            Image(systemName: "chevron.down")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .rotationEffect(.degrees(isExpanded ? -180 : 0))
                            
                                .frame(height: 40)
                            
                        }
                        .onTapGesture {
                            isExpanded.toggle()
                        }
                    } else {
                        /*
                         ScrollViewReader { proxy in
                         ScrollView(.vertical) {
                         VStack(spacing: 10){
                         ForEach(genreLists) { list in
                         Text(list)
                         .foregroundStyle(select == list ? Color.primary : .gray)
                         .frame(height: 40)
                         .padding(.horizontal)
                         .onTapGesture {
                         self.select = list
                         isExpanded.toggle()
                         }
                         }
                         }
                         .onAppear{
                         if let index = genreLists.firstIndex(of: select){
                         proxy.scrollTo(genreLists[index], anchor: .center)
                         }
                         }
                         }
                         .frame(height: 200)
                         .transition(.move(edge: .bottom))
                         }
                         */
                    }
                }
                
            }
            .padding(.horizontal)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.accent, lineWidth: 1)
            )
            
        }
    }
}

struct SortPicker: View {
    
    let genreLists: [String]
    @State private var isExpanded = false
    @Binding var select: String
    
    var body: some View {
        ZStack{
            
            Color.baseBg
                .ignoresSafeArea()
            
            VStack{
                VStack{
                    if !isExpanded{
                        HStack(spacing: 10){
                            Text(select)
                            
                            Image(systemName: "chevron.down")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .rotationEffect(.degrees(isExpanded ? -180 : 0))
                            
                                .frame(height: 40)
                            
                        }
                        .onTapGesture {
                            withAnimation(.snappy){ isExpanded.toggle()}
                        }
                    } else {
                        
                        ScrollViewReader { proxy in
                            ScrollView(.vertical) {
                                VStack(spacing: 10){
                                    ForEach(genreLists, id:\.self) { list in
                                        Text(list)
                                            .foregroundStyle(select == list ? Color.primary : .gray)
                                            .frame(height: 40)
                                            .padding(.horizontal)
                                            .onTapGesture {
                                                self.select = list
                                                isExpanded.toggle()
                                            }
                                    }
                                }
                                .onAppear{
                                    if let index = genreLists.firstIndex(of: select){
                                        proxy.scrollTo(genreLists[index], anchor: .center)
                                    }
                                }
                            }
                            .frame(height: 200)
                            .transition(.move(edge: .bottom))
                        }
                        
                    }
                }
                
            }
            .padding(.horizontal)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.accent, lineWidth: 1)
            )
            
        }
    }
}


//星評価部分
struct RatingView: View {
    
    @Binding var rating: Int
    
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                image(for: number)
                
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
