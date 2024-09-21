//
//  MovieDetailViewModel.swift
//  KinopoiskApiSwiftUI
//
//  Created by Павлов Дмитрий on 21.09.2024.
//

import Foundation
import Network

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var movieDetails: MovieDetails?
    @Published var isLoading = false
    @Published var hasInternetConnection = true
    
    private let networkService: NetworkServiceProtocol
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        startMonitoringNetwork()
    }
    
    
    func fetchMovieDetails(id: Int) async {
        guard hasInternetConnection else { return }
        
        isLoading = true
        
        do {
            let details = try await networkService.getMovieDetails(id: id)
            self.movieDetails = details
        } catch {
            print("Ошибка при загрузке \(error)")
        }
        
        isLoading = false
    }
    
    private func startMonitoringNetwork() {
        monitor.pathUpdateHandler = { path in
            Task { @MainActor in
                self.hasInternetConnection = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
