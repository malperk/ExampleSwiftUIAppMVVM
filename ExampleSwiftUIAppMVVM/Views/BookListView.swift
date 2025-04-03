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
                        await viewModel.loadBooks(reset: true)
                    }
                }
                .refreshable {
                    await viewModel.loadBooks(reset: true)
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading...")

        case .empty:
            Text("No books found.")

        case .failed(let error):
            VStack {
                Text(error).foregroundStyle(.red)
                Button("Retry") {
                    Task { await viewModel.loadBooks(reset: true) }
                }
                .padding()
            }

        case .loaded:
            List {
                ForEach(viewModel.filteredBooks) { book in
                    NavigationLink {
                        BookDetailCoordinator(book: book)
                    } label: {
                        BookRowView(book: book)
                    }
                    .onAppear {
                        if book == viewModel.filteredBooks.last {
                            Task { await viewModel.loadBooks() } // Infinite Scroll
                        }
                    }
                }
            }
        }
    }
}
