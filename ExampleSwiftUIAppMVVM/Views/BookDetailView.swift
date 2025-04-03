import SwiftUI

struct BookDetailView: View {
    let book: Book
    @ObservedObject var viewModel: BookListViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text(book.title)
                .font(.largeTitle)
                .bold()

            Text("by \(book.author)")
                .font(.title2)

            Button {
                viewModel.toggleFavorite(book: book)
            } label: {
                Label("Favorite", systemImage: book.isFavorite ? "star.fill" : "star")
                    .padding()
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Details")
    }
}
