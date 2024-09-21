//
//  MoviesView.swift
//  KinopoiskApiSwiftUI
//
//  Created by Павлов Дмитрий on 20.09.2024.
//

import SwiftUI
import Kingfisher

struct MoviesView: View {
    @StateObject private var viewModel: MoviesViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var alertManager: AlertManager

    init() {
        _viewModel = StateObject(wrappedValue: MoviesViewModel(context: PersistenceController.shared.container.viewContext))
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            List {
                ForEach(viewModel.movies, id: \.id) { movie in
                    MovieRow(movie: movie)
                        .onTapGesture {
                            router.path.append(.movieDetail(movie: movie))
                        }
                        .onAppear {
                            Task {
                                await viewModel.loadNextPageIfNeeded(currentItem: movie)
                            }
                        }
                }
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Фильмы")
            .navigationDestination(for: MovieRoute.self) { route in
                switch route {
                case .movieDetail(let movie):
                    MovieDetailView(movie: movie) 
                }
            }
            .alert(isPresented: $alertManager.showAlert) {
                Alert(
                    title: Text(alertManager.alertTitle),
                    message: Text(alertManager.alertMessage),
                    dismissButton: .default(Text("OK")) {
                        alertManager.showAlert = false
                    }
                )
            }
        }
    }
}
