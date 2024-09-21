//
//  Router.swift
//  KinopoiskApiSwiftUI
//
//  Created by Павлов Дмитрий on 21.09.2024.
//

import Foundation

class Router: ObservableObject {
    @Published var path = [MovieRoute]()
}

enum MovieRoute: Hashable {
    case movieDetail(movie: Doc)
}
