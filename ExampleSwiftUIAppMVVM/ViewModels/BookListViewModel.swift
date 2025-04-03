import Combine

class BookListViewModel: ObservableObject {
    @Published var state: ViewState<[Book]> = .idle
    @Published var searchText: String = ""

    private let repository: BookRepositoryProtocol

    init(repository: BookRepositoryProtocol = BookRepository()) {
        self.repository = repository
    }

    @MainActor
    func loadBooks() async {
        state = .loading
        do {
            let books = try await repository.fetchBooks()
            state = books.isEmpty ? .empty : .loaded(data: books)
        } catch {
            state = .failed(error: "Failed to load books.")
        }
    }

    func toggleFavorite(book: Book) {
        guard case .loaded(var books) = state,
              let index = books.firstIndex(of: book) else { return }

        books[index].isFavorite.toggle()
        state = .loaded(data: books)
    }

    var filteredBooks: [Book] {
        guard case .loaded(let books) = state else { return [] }
        guard !searchText.isEmpty else { return books }
        return books.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
}
