//
//  ReportViewModel.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/12/14.
//

import SwiftUI

class ReportViewModel: ObservableObject {
    //選択したreviewを格納
    @Published var selectedReview: Reviews?
    
    
    ///レポート投稿
    func createReport(reportBody: String, completion: @escaping (Reports) async -> Void) async throws {
        //print("レポート投稿")
        let api = APIConnect(url: URL(string: "\(CommonUrl.url)api/shop/shop/reports/create")!)
        
        if let review = selectedReview {
            let newReportData = CreateReportRequest(
                review_id: review.id,
                report_body: reportBody
            )
            
            do {
                let json = try JSONEncoder().encode(newReportData)
                try await api.postRequest(form: json)
            } catch {
                print("Networking error: \(error)")
            }
        }
    }
    
}

///投稿用
struct CreateReportRequest: Codable {
    let review_id: String
    let report_body: String
}
