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
    
    @State private var isReport: Bool = false
    @State var inputText: String = ""
    
    @State private var isUserReview: Bool = false
    @State private var isUpdate = false
    @State private var oldText = ""
    
    var body: some View {
        ZStack {
            
            Color.baseBg
                .ignoresSafeArea()
            
            VStack{
                NavigationBackButton(){
                    dismiss()
                }
                ScrollView(showsIndicators: false){
                    DetailTitle(genre: "ひつまぶし", shopName: shop.shop_name, review: shop.shop_review, distance: 100, status: shop.shop_now_open, openingTimes: "10時~19時", address: shop.shop_address)
                    
                    Divider()
                    
                    //自分の口コミ
                    if inputText.isEmpty{
                        Button("評価を入力"){
                            oldText = inputText
                            isUpdate = !inputText.isEmpty
                            isUserReview.toggle()
                            
                        }
                    } else {
                        WordOfMouth(review: Reviews.MOCK_REVIEWS[0], isCurrentUser: true)
                        
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
                CreateReviewPage(userName: "ここ修正必要", isUpdate: isUpdate, inputText: $inputText, oldText: oldText)
                    .interactiveDismissDisabled()
                    .presentationDetents([
                        .fraction(1),
                    ])
                
                
            }
        }
        .onAppear{
            Task { await rvm.fetchReviews(shopId: shop.id)}
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
                            oldText = inputText
                            isUpdate = !inputText.isEmpty
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
    DetailPageView(shop: Shops.MOCK_SHOP[0])
}
