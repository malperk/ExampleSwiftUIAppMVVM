import SwiftUI

struct BookListView: View {
    @StateObject private var viewModel = BookListViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .transition(.opacity)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .transition(.opacity)
                } else {
                    List(viewModel.filteredBooks) { book in
                        NavigationLink {
                            BookDetailView(book: book, viewModel: viewModel)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(book.title)
                                        .font(.headline)
                                    Text(book.author)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                if book.isFavorite {
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(.yellow)
                                        .transition(.scale)
                                }
                            }
                        }
                    }
                    .animation(.spring(), value: viewModel.filteredBooks)
                }
            }
            .navigationTitle("Books")
            .searchable(text: $viewModel.searchText)
            .task {
                await viewModel.loadBooks()
            }
        }
    }
}
