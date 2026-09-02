import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.movies.isEmpty {
                    ProgressView("Carregando filmes…")
                } else if let errorMessage = viewModel.errorMessage {
                    ContentUnavailableView(
                        "Algo deu errado",
                        systemImage: "exclamationmark.triangle",
                        description: Text(errorMessage)
                    )
                } else {
                    List(viewModel.movies) { movie in
                        NavigationLink(value: movie) {
                            MovieRowView(movie: movie)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.loadPopularMovies()
                    }
                }
            }
            .navigationTitle("Populares")
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
            .task {
                if viewModel.movies.isEmpty {
                    await viewModel.loadPopularMovies()
                }
            }
        }
    }
}

#Preview {
    MovieListView()
}
