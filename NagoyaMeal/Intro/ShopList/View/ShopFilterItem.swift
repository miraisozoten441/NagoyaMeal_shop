//
//  ShopFilterItem.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/10/31.
//

import SwiftUI

struct ShopFilterItem: View {
    
    @Binding var isGenre: Bool
    @Binding var isSort: Bool
    @Binding var isOpen: Bool
    @Binding var selectGenre: String
    @Binding var selectSort: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                Text("　")
                
                Image(systemName: "slider.horizontal.3")
                    .font(.title2)
                    .foregroundStyle(.accent)
                
                HStack{
                    Text(selectGenre)
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.caption)
                }
                .padding(5)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.accent, lineWidth: 1)
                )
                .onTapGesture {
                    isGenre = true
                }
                
                
                HStack{
                    Text(selectSort)
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.caption)
                }
                .padding(5)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.accent, lineWidth: 1)
                )
                .onTapGesture {
                    isSort = true
                }
                
                if !isOpen{
                    HStack{
                        Text("現在営業中")
                    }
                    .padding(5)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.accent, lineWidth: 1)
                    )
                    .onTapGesture {
                        isOpen.toggle()
                    }
                } else {
                    HStack{
                        Text("現在営業中")
                    }
                    .padding(5)
                    .cornerRadius(5)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.accent)
                    )
                    .foregroundStyle(.black)
                    .onTapGesture {
                        isOpen.toggle()
                    }
                }
                
            }
        }
        .padding(.top)
        .foregroundStyle(.primary)
        
        
    }
}

//#Preview {
//    ShopView()
//}
