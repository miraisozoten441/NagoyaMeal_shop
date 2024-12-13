//
//  APIConnect.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/12/12.
//

import SwiftUI

class APIConnect {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    /// GETしてJSONをもらう
    /// - Returns: JSON等のData
    @discardableResult
    func getRequest() async throws -> Data {
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    /// フォームをPOSTする
    /// - Parameter form: フォーム内容のData
    /// - Returns: JSONのData
    @discardableResult
    func postRequest(form: Data) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = form
        
        // 非同期でデータを取得する
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // HTTPレスポンスが成功かどうかをチェック
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            print("success")
            return data
        } else {
            throw NSError(domain: "HTTPError", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)
        }
    }
    
    // test
    func testConnection() async throws -> Bool {
        let data = try await getRequest()
        let json = try JSONDecoder().decode([String: String].self, from: data)
        if json["Hello"] == "World" {
            return true
        } else {
            return false
        }
    }
}
