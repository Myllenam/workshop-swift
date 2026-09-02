import Foundation
import SwiftUI
internal import Combine

@MainActor
final class MovieSearchViewModel: ObservableObject {
    @Published var query: String = "" {
        didSet { scheduleSearch() }
    }
    @Published var results: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: TMDBService
    private var searchTask: Task<Void, Never>?

    init(service: TMDBService = .shared) {
        self.service = service
    }

    /// Faz debounce simples (300ms) para não disparar uma requisição a cada letra digitada.
    private func scheduleSearch() {
        searchTask?.cancel()

        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            results = []
            errorMessage = nil
            return
        }

        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            guard !Task.isCancelled else { return }
            await performSearch()
        }
    }

    private func performSearch() async {
        isLoading = true
        errorMessage = nil
        do {
            results = try await service.searchMovies(query: query)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
