import Combine
import SwiftUI

struct BookListView: View {
    @StateObject private var viewModel = BookListViewModel()

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            content
                .navigationTitle("Books")
                .searchable(text: $viewModel.searchText)
                .refreshable {
                    await viewModel.loadBooks(reset: true)
                }
                .navigationDestination(for: BookRoute.self) { route in
                    switch route {
                    case .detail(let book):
                        BookDetailCoordinator(book: book)
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
            Text("No books found.")

        case .failed(let error):
            VStack {
                Text(error).foregroundStyle(.red)
                Button("Retry") {
                    Task { await viewModel.loadBooks(reset: true) }
                }
            }

        case .loaded:
            List {
                ForEach(viewModel.filteredBooks) { book in
                    Button {
                        viewModel.navigateToDetail(book: book)
                    } label: {
                        BookRowView(book: book)
                    }
//                    .onAppear {
//                        if book == viewModel.filteredBooks.last {
//                            Task { await viewModel.loadBooks() }
//                        }
//                    }
                }
            }
        }
    }
}
