import Foundation

// MARK: - Movie

/// Representa um filme retornado pela API do TMDB.
struct Movie: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let genreIds: [Int]?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case genreIds = "genre_ids"
    }

    /// URL completa do poster, pronta para usar em AsyncImage.
    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }

    /// URL completa do backdrop (imagem de fundo maior), usada na tela de detalhes.
    var backdropURL: URL? {
        guard let backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)")
    }

    var formattedRating: String {
        guard let voteAverage else { return "N/A" }
        return String(format: "%.1f", voteAverage)
    }

    var releaseYear: String {
        guard let releaseDate, releaseDate.count >= 4 else { return "—" }
        return String(releaseDate.prefix(4))
    }
}

// MARK: - Respostas da API

/// Envelope padrão do TMDB para endpoints de lista (popular, search, etc).
struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
