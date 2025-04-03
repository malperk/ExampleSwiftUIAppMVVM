import Foundation

class BookListViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var searchText: String = ""
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false

    private let repository: BookRepositoryProtocol

    init(repository: BookRepositoryProtocol = BookRepository()) {
        self.repository = repository
    }

    @MainActor
    func loadBooks() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            books = try await repository.fetchBooks()
        } catch {
            errorMessage = "Failed to load books."
        }
    }

    var filteredBooks: [Book] {
        guard !searchText.isEmpty else { return books }
        return books.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    func toggleFavorite(book: Book) {
        guard let index = books.firstIndex(where: { $0.id == book.id }) else { return }
        books[index].isFavorite.toggle()
    }
}
