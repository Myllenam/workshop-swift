import SwiftUI

@main
struct MovieExplorerApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
    }
}

struct RootTabView: View {
    var body: some View {
        TabView {
            MovieListView()
                .tabItem {
                    Label("Populares", systemImage: "list.bullet")
                }

            MovieSearchView()
                .tabItem {
                    Label("Buscar", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    RootTabView()
}
