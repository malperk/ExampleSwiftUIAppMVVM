import SwiftUI

struct BookDetailView: View {
    @ObservedObject var viewModel: BookDetailViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.book.title)
                .font(.largeTitle)
                .bold()

            Text("by \(viewModel.book.author)")
                .font(.title2)

            Button {
                viewModel.toggleFavorite()
            } label: {
                Label("Favorite", systemImage: viewModel.book.isFavorite ? "star.fill" : "star")
                    .padding()
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Details")
    }
}
