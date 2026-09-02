import SwiftUI

struct MovieDetailView: View {
    let movie: Movie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: movie.backdropURL ?? movie.posterURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    default:
                        Color.secondary.opacity(0.2)
                    }
                }
                .frame(height: 220)
                .clipped()

                VStack(alignment: .leading, spacing: 12) {
                    Text(movie.title)
                        .font(.title2)
                        .bold()

                    HStack(spacing: 16) {
                        Label(movie.releaseYear, systemImage: "calendar")
                        Label(movie.formattedRating, systemImage: "star.fill")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    Divider()

                    Text("Sinopse")
                        .font(.headline)

                    Text(movie.overview.isEmpty ? "Sem sinopse disponível." : movie.overview)
                        .font(.body)
                        .foregroundStyle(.primary)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(
            movie: Movie(
                id: 1,
                title: "Filme de Exemplo",
                overview: "Uma sinopse de exemplo para o preview funcionar sem chamar a API.",
                posterPath: nil,
                backdropPath: nil,
                releaseDate: "2024-05-01",
                voteAverage: 8.2,
                genreIds: []
            )
        )
    }
}
