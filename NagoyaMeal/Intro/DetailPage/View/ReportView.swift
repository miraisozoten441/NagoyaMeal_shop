//
//  ReportView.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/10/31.
//

import SwiftUI

struct ReportView: View {
    @State private var showPopup = false
    @State private var selectedReport: String?
    @Environment(\.dismiss) var dismiss
    
    
    let reports = [
        ("関連性のないコンテンツ", "このビジネスでの経験とは関係ないクチコミ"),
        ("スパム", "ボットまたは虚偽のアカウントからのクチコミ、あるいは広告かプロモーションを含むクチコミ"),
        ("利害に関する問題", "該当のビジネスまたは競合するビジネスと関係するユーザーが投稿したクチコミ"),
        ("冒涜的な表現", "汚い言葉、露骨な性描写、詳細な暴力描写を含むクチコミ"),
        ("いじめ、嫌がらせ", "特定の人を個人的に攻撃するクチコミ"),
        ("人種差別、ヘイトスピーチ", "身元を理由に個人またはグループを中傷する表現を含むクチコミ"),
        ("個人情報", "住所や電話番号などの個人情報を含むクチコミ"),
        ("役に立たなかった", "この場所に行くかどうかを決めるのに関係ないクチコミ")
    ]
    
    var body: some View {
        ZStack{
            Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
            
            VStack{
                NavigationBackButton(){
                    dismiss()
                }
                
                Text("口コミの報告")
                    .font(.title)
                
                List(reports, id: \.0) { report in
                    
                    Button(action: {
                        selectedReport = report.0
                        showPopup = true
                    }) {
                        VStack(alignment: .leading) {
                            Text(report.0)
                                .font(.headline)
                            Text(report.1)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .confirmationDialog("この内容を報告しますか？", isPresented: $showPopup, titleVisibility: .visible) {
                    Button("報告する", role: .destructive) {
                        // 報告の処理をここに記載
                        print("\(selectedReport ?? "")を報告しました")
                    }
                    Button("キャンセル", role: .cancel) {}
                }
            }
        }
        
    }
}

#Preview {
    ReportView()
}
