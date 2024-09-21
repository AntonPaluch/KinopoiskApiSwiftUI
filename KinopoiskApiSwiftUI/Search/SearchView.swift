//
//  SearchView.swift
//  KinopoiskApiSwiftUI
//
//  Created by Павлов Дмитрий on 20.09.2024.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                TextField("Search", text: $viewModel.searchText, onCommit: {
                    UIApplication.shared.endEditing()
                })
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if viewModel.isLoading && viewModel.movies.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                List {
                    ForEach(viewModel.movies, id: \.id) { movie in
                        MovieRow(movie: movie)
                            .onTapGesture {
                                router.path.append(.movieDetail(movie: movie))
                            }
                            .onAppear {
                                if movie == viewModel.movies.last {
                                    Task {
                                        await viewModel.searchMovies(query: viewModel.searchText)
                                    }
                                }
                            }
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Поиск фильмов")
            .navigationDestination(for: MovieRoute.self) { route in
                switch route {
                case .movieDetail(let movie):
                    MovieDetailView(movie: movie)
                }
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
    }
}
