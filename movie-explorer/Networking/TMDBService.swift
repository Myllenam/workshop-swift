import Foundation

// MARK: - Erros

enum TMDBError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case requestFailed(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida."
        case .invalidResponse:
            return "Resposta inválida do servidor."
        case .decodingFailed:
            return "Não foi possível interpretar os dados recebidos."
        case .requestFailed(let code):
            return "Falha na requisição (código \(code))."
        }
    }
}

// MARK: - TMDBService

/// Camada responsável por conversar com a API pública do TMDB.
///
/// Crie uma conta gratuita em https://www.themoviedb.org/, gere uma
/// "API Read Access Token" (v4 auth) em Configurações > API, e cole
/// abaixo em `apiKey`. NUNCA suba essa chave para um repositório público
/// em um projeto real — aqui está simplificado propositalmente para o workshop.
final class TMDBService {
    nonisolated static let shared = TMDBService()

    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String
    private let baseURL = "https://api.themoviedb.org/3"

    private init() {}

    /// Busca a lista de filmes populares (usada na tela de Lista).
    func fetchPopularMovies(page: Int = 1) async throws -> [Movie] {
        try await request(path: "/movie/popular", queryItems: [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "language", value: "pt-BR")
        ])
    }

    /// Busca filmes por texto (usada na tela de Busca).
    func searchMovies(query: String, page: Int = 1) async throws -> [Movie] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }
        return try await request(path: "/search/movie", queryItems: [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "language", value: "pt-BR")
        ])
    }

    // MARK: - Privado
    
    /// <#Description#>
    /// - Parameters:
    ///   - path: <#path description#>
    ///   - queryItems: <#queryItems description#>
    /// - Returns: <#description#>
    private func request(path: String, queryItems: [URLQueryItem]) async throws -> [Movie] {
        guard var components = URLComponents(string: baseURL + path) else {
            throw TMDBError.invalidURL
        }
        components.queryItems = queryItems

        guard let url = components.url else {
            throw TMDBError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        guard let apiKey else {
            throw TMDBError.invalidURL
        }
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw TMDBError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw TMDBError.requestFailed(httpResponse.statusCode)
        }

        do {
            let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
            return decoded.results
        } catch {
            throw TMDBError.decodingFailed
        }
    }
}
