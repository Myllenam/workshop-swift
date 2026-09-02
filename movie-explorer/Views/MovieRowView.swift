import SwiftUI

struct MovieRowView: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    posterPlaceholder(systemImage: "film")
                case .empty:
                    ProgressView()
                @unknown default:
                    posterPlaceholder(systemImage: "photo")
                }
            }
            .frame(width: 60, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)

                Text(movie.releaseYear)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .font(.caption)
                    Text(movie.formattedRating)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }

    private func posterPlaceholder(systemImage: String) -> some View {
        ZStack {
            Color.secondary.opacity(0.2)
            Image(systemName: systemImage)
                .foregroundStyle(.secondary)
        }
    }
}
