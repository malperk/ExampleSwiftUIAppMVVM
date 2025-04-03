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
                .transition(.opacity)

        case .failed(let message):
            VStack {
                Text(message)
                    .foregroundStyle(.red)
                Button("Retry") {
                    Task { await viewModel.loadBooks() }
                }
                .padding()
            }
            .transition(.opacity)

        case .loaded:
            List(viewModel.filteredBooks) { book in
                NavigationLink {
                    BookDetailView(book: book, viewModel: viewModel)
                } label: {
                    BookRowView(book: book)
                }
            }
            .animation(.default, value: viewModel.filteredBooks)
        }
    }
}
