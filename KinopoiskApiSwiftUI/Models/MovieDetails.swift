//
//  MovieDetails.swift
//  KinopoiskApiSwiftUI
//
//  Created by Павлов Дмитрий on 19.09.2024.
//

struct MovieDetails: Decodable {
    let videos: Videos
    let genres: [Genres]
    let persons: [Persons]
}

struct Videos: Decodable {
    let trailers: [Trailer]
}

struct Trailer: Decodable {
    let url: String
}

struct Genres: Decodable {
    let name: String
}

struct Persons: Decodable {
    let name: String?
    let description: String?
    let enProfession: String?
    let photo: String?
}
