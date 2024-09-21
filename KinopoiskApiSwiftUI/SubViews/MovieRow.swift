//
//  MovieRow.swift
//  KinopoiskApiSwiftUI
//
//  Created by Павлов Дмитрий on 20.09.2024.
//

import SwiftUI
import Kingfisher

struct MovieRow: View {
    let movie: Doc

    var body: some View {
        HStack {
            KFImage(URL(string: movie.poster?.url ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 90)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(movie.name ?? movie.alternativeName ?? "")
                    .font(.headline)
                if let year = movie.year {
                    Text("\(Texts.year) \(year)")
                        .font(.subheadline)
                }
                if let rating = movie.rating.kp {
                    Text("\(Texts.rating) \(rating, specifier: "%.1f")")
                        .font(.subheadline)
                }
            }
            .padding(.leading, 8)
            Spacer()
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
    
    enum Texts {
        static let year = "Год выпуска:"
        static let rating = "Рейтинг:"
    }
}
