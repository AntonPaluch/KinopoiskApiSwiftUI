//
//  MovieDetailView.swift
//  KinopoiskApiSwiftUI
//
//  Created by Павлов Дмитрий on 21.09.2024.
//

import SwiftUI
import Kingfisher

struct MovieDetailView: View {
    let movie: Doc
    @StateObject private var viewModel: MovieDetailViewModel
    
    init(movie: Doc, networkService: NetworkServiceProtocol) {
        self.movie = movie
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(networkService: networkService))
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    if let movieDetails = viewModel.movieDetails, viewModel.hasInternetConnection {

                        movieInfoView(movie: movie, movieDetails: movieDetails)
                        
                        if let trailerURLString = movieDetails.videos.trailers.first?.url,
                           let trailerURL = URL(string: trailerURLString) {
                            Text(Texts.trailer)
                                .font(.headline)
                                .padding(.top, 10)
                            
                            TrailerWebView(url: trailerURL)
                                .frame(height: 300)
                                .cornerRadius(8)
                                .padding(.horizontal, 10)
                        }
                        
                        if !movieDetails.persons.filter({ $0.enProfession == "actor" }).isEmpty {
                            Text(Texts.actors)
                                .font(.headline)
                                .padding(.top, 10)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(movieDetails.persons.filter({ $0.enProfession == "actor" }), id: \.name) { person in
                                        VStack {
                                            if let photoURL = URL(string: person.photo ?? "") {
                                                KFImage(photoURL)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 100, height: 150)
                                                    .cornerRadius(8)
                                            }
                                            
                                            Text(person.name ?? "")
                                                .font(.caption)
                                                .lineLimit(1)
                                        }
                                    }
                                }
                                .padding(.horizontal, 10)
                            }
                        }
                    } else {
                        movieInfoView(movie: movie)
                    }
                }
                .padding()
            }
            
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                ProgressView()
                    .scaleEffect(2)
                    .padding()
            }
        }
        .navigationTitle(movie.name ?? movie.alternativeName ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                if viewModel.hasInternetConnection {
                    viewModel.isLoading = true
                    await viewModel.fetchMovieDetails(id: movie.id)
                    viewModel.isLoading = false
                }
            }
        }
    }
    
    @ViewBuilder
     private func posterView(urlString: String?) -> some View {
         if let urlString = urlString, let imageURL = URL(string: urlString) {
             ZStack {
                 KFImage(imageURL)
                     .resizable()
                     .aspectRatio(contentMode: .fill)
                     .cornerRadius(15)
                     .frame(maxWidth: .infinity)
                     .frame(height: 300)
                     .clipped()
                     .blur(radius: 20)
                 
                 KFImage(imageURL)
                     .resizable()
                     .cornerRadius(15)
                     .aspectRatio(contentMode: .fit)
                     .frame(maxWidth: .infinity)
             }
             .frame(height: 300)
         }
     }
    
    @ViewBuilder
        private func movieInfoView(movie: Doc, movieDetails: MovieDetails? = nil) -> some View {
            posterView(urlString: movie.poster?.url)
            
            Text(movie.name ?? movie.alternativeName ?? "")
                .font(.title)
                .padding(.bottom, 10)
            
            if let year = movie.year {
                Text("\(Texts.year) \(year)")
                    .font(.subheadline)
            }
            
            if let rating = movie.rating.kp {
                Text("\(Texts.rating) \(rating, specifier: "%.1f")")
                    .font(.subheadline)
            }
            
            if let movieLength = movie.movieLength {
                let hours = movieLength / 60
                let minutes = movieLength % 60
                Text("\(Texts.length) \(hours)ч \(minutes)м")
                    .font(.subheadline)
            }
            
            Text(movie.description ?? "")
                .padding(.top, 10)
                .font(.body)

            if let movieDetails = movieDetails {
                Text("\(Texts.genres) \(movieDetails.genres.map { $0.name }.joined(separator: ", "))")
                    .font(.subheadline)
                    .padding(.bottom, 10)
            }
        }
    
    enum Texts {
        static let year = "Год выпуска:"
        static let rating = "Рейтинг:"
        static let genres = "Жанр:"
        static let trailer = "Трейлер"
        static let actors = "Актеры"
        static let length = "Продолжительность:"
    }
}
