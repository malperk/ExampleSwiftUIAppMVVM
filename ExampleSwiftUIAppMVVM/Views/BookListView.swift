import SwiftUI

struct BookListView: View {
    @StateObject private var viewModel = BookListViewModel()

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Books")
                .searchable(text: $viewModel.searchText)
                .task(id: viewModel.state) {
                    if case .idle = viewModel.state {
                        await viewModel.loadBooks()
                    }
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading...")

        case .empty:
            Text("No books available.")

        case .failed(let error):
            VStack {
                Text(error).foregroundStyle(.red)
                Button("Retry") {
                    Task { await viewModel.loadBooks() }
                }
            }

        case .loaded:
            List(viewModel.filteredBooks) { book in
                NavigationLink {
                    BookDetailView(book: book, viewModel: viewModel)
                } label: {
                    BookRowView(book: book)
                }
            }
        }
    }
}
