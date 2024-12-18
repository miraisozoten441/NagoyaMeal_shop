//
//  DetailPageView.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/10/31.
//

import SwiftUI

struct DetailPageView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var rvm = ReviewViewModel()
    @StateObject var reportvm = ReportViewModel()
    @ObservedObject var svm: ShopViewModel
    
    let shop: FavoriteShops
    let currentUser: String
    
    @State private var isReport: Bool = false
    @State var inputText: String = ""
    
    @State private var isUserReview: Bool = false
    @State private var isUpdate = false
    
    @State var isAlert: Bool = false
    
    var body: some View {
        ZStack {

            Color.baseBg
                .ignoresSafeArea()
            
            VStack{
                NavigationBackButton(){
                    dismiss()
                }
                ScrollView(showsIndicators: false){
                    DetailTitle(currentUser: currentUser, shop: shop, svm: svm)
                    
                    Divider()
                    
                    //自分の口コミ
                    if let myReview = rvm.myReview {
                        WordOfMouth(review: myReview, isCurrentUser: true)
                    } else {
                        Button("評価を入力"){
                            if !currentUser.isEmpty {
                                isUserReview.toggle()
                            } else {
                                isAlert.toggle()
                            }
                        }
                        .alert("ログインをしてください", isPresented: $isAlert) {
                            
                        } message: {
                            Text("評価機能を利用するにはログインを行なってください。")
                        }
                    }
                    
                
                    Divider()
                    
                    
                    //他の人の口コミ
                    ForEach(rvm.reviews){ review in
                        WordOfMouth(review: review)
                        Divider()
                    }
                    
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $isReport){
                
                ReportView(reportvm: reportvm)
                
                
            }
            .sheet(isPresented: $isUserReview){
                CreateReviewPage(currentUser: currentUser, shop: shop, isUpdate: $isUpdate, rvm: rvm)
                    .interactiveDismissDisabled()
                    .presentationDetents([
                        .fraction(1),
                    ])
                
                
            }
        }
        .onAppear{
            svm.selectShop = shop
            Task { await rvm.fetchReviews(shopId: shop.id, currentUser: currentUser)}
        }
        
        
        
    }

    @ViewBuilder
    func WordOfMouth(review: Reviews, isCurrentUser: Bool = false) -> some View {
            VStack(alignment: .leading){
                //ユーザー
                HStack{
                    // ここの値はアプリ実装後に変更する
                    AsyncImage(url: URL(string: CommonUrl.url + "api/systemuser/icon/000806.935b64c05d124123ae215f6382d03267.0438.jpeg")) { image in
                        image.resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .foregroundStyle(Color(.systemGray4))
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .foregroundStyle(Color(.systemGray4))
                    }
                                            
                    
                    Text(review.user_name)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    if isCurrentUser{
                        Button{
                            if let _ = rvm.myReview {
                                rvm.inputText = review.review_body
                                rvm.raiting = review.review_point
                                isUpdate = true
                            }
                            isUserReview.toggle()
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                    }
                    
                }
                
                //評価 & 投稿日
                HStack{
                    HStack{
                        StarRating(rating: Float(review.review_point))
                            .foregroundStyle(Color.yellow)
                        Text(review.review_updateDate=="" ? review.review_createDate: review.review_updateDate)
                            .font(.caption)
                    }
                }
                
                //本文
                HStack{
                    Text(review.review_body)
                }
                if !isCurrentUser{
                    HStack{
                        Spacer()
                        Button{
                            reportvm.selectedReview = review
                            
                            isReport = true
                            
                            
                        }label: {
                            HStack{
                                Text("")
                                    .font(.title3)
                                Image(systemName: "exclamationmark.triangle.fill")
                            }
                        }
                        
                        
                    }
                    .padding(.top, 3)
                    
                }
            }
            
        
        
    }
}

#Preview {
    let shop =  FavoriteShops(id: "1", shop_name: "1", shop_review: 1, shop_now_open: true, shop_address: "w", shop_phoneNumber: "0", genres: Genres.MOCK_GENRE, works_times: WorksTimes.MOCK_WORKS, isFavorite: true)
    DetailPageView(svm: ShopViewModel(), shop: shop, currentUser: "a")
}
