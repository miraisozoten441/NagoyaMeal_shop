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
    
    let shop: Shops
    let currentUser: String
    
    @State private var isReport: Bool = false
    @State var inputText: String = ""
    
    @State private var isUserReview: Bool = false
    @State private var isUpdate = false
    
    var body: some View {
        ZStack {

            Color.baseBg
                .ignoresSafeArea()
            
            VStack{
                NavigationBackButton(){
                    dismiss()
                }
                ScrollView(showsIndicators: false){
                    DetailTitle(genre: "ひつまぶし", shopName: shop.shop_name, review: shop.shop_review, status: shop.shop_now_open, openingTimes: "10時~19時", address: shop.shop_address)
                    
                    Divider()
                    
                    //自分の口コミ
                    if let myReview = rvm.myReview {
                        WordOfMouth(review: myReview, isCurrentUser: true)
                    } else {
                        Button("評価を入力"){
                            isUserReview.toggle()
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
                ReportView()
            }
            .sheet(isPresented: $isUserReview){
                CreateReviewPage(currentUser: currentUser, shop: shop, isUpdate: isUpdate, rvm: rvm)
                    .interactiveDismissDisabled()
                    .presentationDetents([
                        .fraction(1),
                    ])
                
                
            }
        }
        .onAppear{
            Task { await rvm.fetchReviews(shopId: shop.id, currentUser: currentUser)}
        }
        
        
        
    }

    @ViewBuilder
    func WordOfMouth(review: Reviews, isCurrentUser: Bool = false) -> some View {
            VStack(alignment: .leading){
                //ユーザー
                HStack{
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .foregroundStyle(Color(.systemGray4))
                    
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
                            isReport = true
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
            }
            
        
        
    }
}

#Preview {
    DetailPageView(shop: Shops.MOCK_SHOP[0], currentUser: "test_token1")
}
