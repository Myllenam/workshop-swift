import Foundation
import SwiftUI
internal import Combine

@MainActor
final class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: TMDBService

    init(service: TMDBService = .shared) {
        self.service = service
    }

    func loadPopularMovies() async {
        isLoading = true
        errorMessage = nil
        do {
            movies = try await service.fetchPopularMovies()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
