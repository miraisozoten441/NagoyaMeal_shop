//
//  GenresViewModel.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/11/25.
//

import SwiftUI

class GenreViewModel: ObservableObject {
    @Published var genres: [Genres] = []
    
    init(){
        Task{
            await fetchGenres()
        }
    }

    func fetchGenres() async {
        guard let url = URL(string: "\(CommonUrl.url)api/shop/shop/genres/genres") else {
            print("Invalid URL")
            return
        }

        let api = APIConnect(url: url)
        do {
            let data = try await api.getRequest()
            let decodedGenres = try JSONDecoder().decode([Genres].self, from: data)
            //print("API Response: \(decodedGenres)")
            await MainActor.run {
                self.genres = decodedGenres
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
