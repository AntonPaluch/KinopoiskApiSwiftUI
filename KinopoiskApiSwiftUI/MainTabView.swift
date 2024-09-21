//
//  MainTabView.swift
//  KinopoiskApiSwiftUI
//
//  Created by Павлов Дмитрий on 20.09.2024.
//

import SwiftUI

struct MainTabView: View {
    let networkService: NetworkService
    
    var body: some View {
        TabView {
            MoviesView(networkService: networkService)
                .tabItem {
                    Image(systemName: "film")
                    Text(Texts.movies)
                }
            SearchView(networkService: networkService)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text(Texts.search)
                }
        }
    }
    
    enum Texts {
        static let movies = "Фильмы"
        static let search = "Поиск"
    }
}
