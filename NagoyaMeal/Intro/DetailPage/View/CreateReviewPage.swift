//
//  CreateReviewPage.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/10/31.
//

import SwiftUI

struct CreateReviewPage: View {
    
    let currentUser: String
    let shop: FavoriteShops
    let isUpdate: Bool
    
    @ObservedObject var rvm: ReviewViewModel
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    rvm.inputText = ""
                    rvm.raiting = 0
                    dismiss()
                } label: {
                    Text("キャンセル")
                        .font(.title3)
                }
                
                Spacer()
                
                if isUpdate{
                    Button{
                        if let myReview = rvm.myReview {
                            rvm.myReview = nil
                            Task{
                                do{
                                    try await rvm.deleteReview(id: myReview.id) {data in
                                        await MainActor.run {
                                            print("削除")
                                            
                                        }
                                        await rvm.fetchReviews(shopId: shop.id, currentUser: currentUser)
                                        await MainActor.run {
                                            rvm.inputText = ""
                                            rvm.raiting = 0
                                            
                                        }
                                    }
                                } catch {
                                    print("Delete error: \(error)")
                                }
                                dismiss()
                            }
                        }
                        
                    } label: {
                        Text("削除")
                            .font(.title3)
                    }
                }
            }
            .padding(.bottom)
            Spacer()
            
            
            //星部分
            HStack{
                CreateRatingView(rating: $rvm.raiting)
            }
            .padding()
            
            
            HStack{
                TextEditor(text: $rvm.inputText)
                //.frame(width: .infinity, height: 300)
                    .lineLimit(5)
                    .border(.gray)
                    .onChange(of: rvm.inputText) { oldValue, newValue in
                        if newValue.count > 255 {
                            rvm.inputText = oldValue
                        }
                    }
                
            }
            
            VStack{
                Button{
                    if isUpdate {
                        Task {
                            if let myReview = rvm.myReview {
                                try await rvm.updateReview(id: myReview.id) {data in
                                    await MainActor.run {
                                        print("更新")
                                    }
                                }
                                await rvm.fetchReviews(shopId: shop.id, currentUser: currentUser)
                                rvm.inputText = ""
                                rvm.raiting = 0
                            }
                        }
                    } else {
                        Task {
                            try await rvm.createReview(shopId: shop.id, userId: currentUser) {data in
                                await MainActor.run {
                                    print("送信")
                                }
                                
                            }
                            await rvm.fetchReviews(shopId: shop.id, currentUser: currentUser)
                            rvm.inputText = ""
                            rvm.raiting = 0
                        }
                    }
                    dismiss()
                }label: {
                    Text(isUpdate ? "更新" :"送信")
                        .font(.title3)
                        .padding(10)
                        .frame(maxWidth: 150)
                        .foregroundColor(.white)
                        .background(rvm.inputText.isEmpty ? .gray: .accent)
                        .cornerRadius(30)
                }.disabled(rvm.inputText.isEmpty)
                
                
            }
            .padding()
            
            Spacer()
            
        }
        .padding()
        
    }
}

#Preview {
    //    DetailPageView(shop: <#Shops#>)
}
