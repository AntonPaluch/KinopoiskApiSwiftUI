//
//  MainTabView.swift
//  KinopoiskApiSwiftUI
//
//  Created by Павлов Дмитрий on 20.09.2024.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MoviesView()
                .tabItem {
                    Image(systemName: "film")
                    Text(Texts.movies)
                }
            SearchView()
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

#Preview {
    MainTabView()
}
