//
//  MoviesViewModel.swift
//  KinopoiskApiSwiftUI
//
//  Created by Павлов Дмитрий on 20.09.2024.
//

import Foundation
import CoreData
import Network

class MoviesViewModel: ObservableObject {
    @Published var movies: [Doc] = []
    @Published var isLoading = false
    @Published var showCoreDataMovies = false
    @Published var hasInternetConnection = true
    
    private var currentPage = 1
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    
    private var viewContext: NSManagedObjectContext
    private let networkService: NetworkServiceProtocol
    
    init(context: NSManagedObjectContext, networkService: NetworkServiceProtocol) {
        self.viewContext = context
        self.networkService = networkService
        startMonitoringNetwork()
        Task {
            await loadMovies()
        }
    }
    
    @MainActor
    func loadMovies(refresh: Bool = false) async {
        
        if refresh {
            currentPage = 1
            movies.removeAll()
        }
        
        guard !isLoading else { return }
        isLoading = true
        
        if hasInternetConnection {
            do {
                let response = try await networkService.getBestMovies(page: currentPage)
                self.movies.append(contentsOf: response.docs)
                self.currentPage += 1
                await saveMoviesToCoreData(movies: response.docs)
            } catch {
                AlertManager.shared.showAlert(
                    title: "Ошибка",
                    message: "Не удалось загрузить фильмы с сервера. Попробуйте позже."
                )
                await loadMoviesFromCoreData()
            }
        } else {
            AlertManager.shared.showAlert(
                title: "Нет соединения",
                message: "Отсутствует подключение к интернету. Загрузка данных из кэша."
            )
            await loadMoviesFromCoreData()
        }
        
        isLoading = false
    }
    
    func loadNextPageIfNeeded(currentItem: Doc) async {
        guard !isLoading else { return }
        
        if hasInternetConnection, currentItem == movies.last {
            await loadMovies()
        }
    }
    
    private func loadMoviesFromCoreData() async {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        
        do {
            let movieEntities = try viewContext.fetch(fetchRequest)
            let coreDataMovies = movieEntities.map { Doc.fromCoreData($0) }
            await MainActor.run {
                self.movies = coreDataMovies
            }
        } catch {
            print("Ошибка \(error)")
        }
    }
    
    private func saveMoviesToCoreData(movies: [Doc]) async {
        await viewContext.perform {
            for movie in movies {
                if !self.isMovieExist(id: Int64(movie.id)) {
                    let newMovie = MovieEntity(context: self.viewContext)
                    newMovie.id = Int64(movie.id)
                    newMovie.name = movie.name ?? movie.alternativeName ?? ""
                    newMovie.year = Int64(movie.year ?? 0)
                    newMovie.rating = movie.rating.kp ?? 0.0
                    newMovie.movieLength = Int64(movie.movieLength ?? 0)
                    newMovie.posterUrl = movie.poster?.url
                    newMovie.descriptionText = movie.description
                }
            }
            do {
                try self.viewContext.save()
            } catch {
                print("Ошибка при сохранении фильмов в Core Data: \(error)")
            }
        }
    }
    
    private func isMovieExist(id: Int64) -> Bool {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Ошибка core Data: \(error)")
            return false
        }
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
