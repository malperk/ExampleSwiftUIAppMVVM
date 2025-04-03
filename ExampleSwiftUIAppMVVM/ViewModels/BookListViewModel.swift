import Foundation

class BookListViewModel: ObservableObject {
    @Published var state: Loadable<[Book]> = .idle
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
            state = .loaded(books)
        } catch {
            state = .failed("Failed to load books. Please try again.")
        }
    }

    func toggleFavorite(book: Book) {
        guard case .loaded(var books) = state,
              let index = books.firstIndex(of: book) else { return }

        books[index].isFavorite.toggle()
        state = .loaded(books)
    }

    var filteredBooks: [Book] {
        guard case .loaded(let books) = state else { return [] }
        guard !searchText.isEmpty else { return books }
        return books.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
}
