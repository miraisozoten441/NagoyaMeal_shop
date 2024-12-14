//
//  1Environments.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/12/14.
//

import Foundation

class EnvironmentsSettings: ObservableObject {
    @Published var user: UserData = UserData(token: "", name: "", icon: "", circle_id: nil)
    @Published var circle: CreateForm?
    @Published var isLogin: Bool = false
    
    init() {
        self.user.token = UserDefaults.standard.string(forKey: "token") ?? ""
        self.user.name = UserDefaults.standard.string(forKey: "name") ?? ""
        self.user.icon = UserDefaults.standard.string(forKey: "icon") ?? ""
        self.user.circle_id = UserDefaults.standard.string(forKey: "circle_id") ?? ""
        self.isLogin = UserDefaults.standard.bool(forKey: "isUserLogin")
    }
}

struct CreateForm: Codable {
    var id: String = ""
    var name: String = ""
    var description: String = ""
    var leader_id: String = ""
    var point_id: String = ""
}

struct UserData: Codable {
    var token: String
    var name: String
    var icon: String
    var circle_id: String?
}
