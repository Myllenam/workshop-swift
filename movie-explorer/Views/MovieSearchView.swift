import SwiftUI

struct MovieSearchView: View {
    @StateObject private var viewModel = MovieSearchViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    ContentUnavailableView(
                        "Busque um filme",
                        systemImage: "magnifyingglass",
                        description: Text("Digite um título para começar a busca.")
                    )
                } else if viewModel.isLoading {
                    ProgressView("Buscando…")
                } else if let errorMessage = viewModel.errorMessage {
                    ContentUnavailableView(
                        "Algo deu errado",
                        systemImage: "exclamationmark.triangle",
                        description: Text(errorMessage)
                    )
                } else if viewModel.results.isEmpty {
                    ContentUnavailableView.search(text: viewModel.query)
                } else {
                    List(viewModel.results) { movie in
                        NavigationLink(value: movie) {
                            MovieRowView(movie: movie)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Buscar")
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
            .searchable(text: $viewModel.query, prompt: "Nome do filme")
        }
    }
}

#Preview {
    MovieSearchView()
}
