//
//  CreateReviewPage.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/10/31.
//

import SwiftUI

/// test
struct CreateReviewPage: View {
    
    let userName: String
    let isUpdate: Bool
    
    @State private var rating = 0
    
    @Binding var inputText: String
    let oldText: String
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    inputText = oldText
                    dismiss()
                } label: {
                    Text("キャンセル")
                        .font(.title3)
                }
                
                Spacer()
            }
            .padding(.bottom)
            Spacer()
            
            
            //ユーザーname
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
            
            //星部分
            HStack{
                CreateRatingView(rating: $rating)
            }
            .padding()
            
            
            HStack{
                TextEditor(text: $inputText)
                    //.frame(width: .infinity, height: 300)
                    .lineLimit(5)
                    .border(.gray)
                    .onChange(of: inputText) { oldValue, newValue in
                        if newValue.count > 255 {
                            inputText = oldValue
                        }
                    }
                    
            }
            
            VStack{
                Button{
                    print("送信")
                    dismiss()
                }label: {
                    Text(isUpdate ? "更新" :"送信")
                        .font(.title3)
                        .padding(10)
                        .frame(maxWidth: 150)
                        .foregroundColor(.white)
                        .background(inputText.isEmpty ? .gray: .accent)
                        .cornerRadius(30)
                }.disabled(inputText.isEmpty)

                
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
