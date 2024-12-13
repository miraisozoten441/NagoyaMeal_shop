//
//  GenresViewModel.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/11/25.
//

import SwiftUI

class GenreViewModel: ObservableObject {
    @Published var genres: [Genres] = []
    
    init() {
        fetchGenres()
    }

    func fetchGenres() {
        guard let url = URL(string: "\(CommonUrl.url)api/shop/shop/genres/genres") else { return }
        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedGenres = try JSONDecoder().decode([Genres].self, from: data)
                    DispatchQueue.main.async {
                        self.genres = decodedGenres
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
        }.resume()
    }
}
