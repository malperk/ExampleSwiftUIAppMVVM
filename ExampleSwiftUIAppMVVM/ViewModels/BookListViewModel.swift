import Combine
import SwiftUI

class BookListViewModel: ObservableObject {
    @Published var state: ViewState<[Book]> = .idle
    @Published var searchText: String = ""
    @Published var path: NavigationPath = NavigationPath()
    
    private let repository: BookRepositoryProtocol
    private var currentPage = 1
    private var hasMore = true
    private var isLoadingMore = false

    init(repository: BookRepositoryProtocol = BookRepository()) {
        self.repository = repository
        Task { await loadBooks(reset: true) }
    }

    @MainActor
    func loadBooks(reset: Bool = false) async {
        if isLoadingMore { return }

        if reset {
            currentPage = 1
            hasMore = true
            state = .loading
        } else if !hasMore {
            return
        }

        isLoadingMore = true

        do {
            let newBooks = try await repository.fetchBooksPage(page: currentPage)
            currentPage += 1
            hasMore = newBooks.count >= 3

            switch state {
            case .loaded(let existing):
                state = .loaded(data: existing + newBooks)
            default:
                state = newBooks.isEmpty ? .empty : .loaded(data: newBooks)
            }
        } catch {
            if case .loaded(let existing) = state, !existing.isEmpty {
                state = .loaded(data: existing)
            } else {
                state = .failed(error: "Failed to load books.")
            }
        }

        isLoadingMore = false
    }

    func toggleFavorite(book: Book) {
        guard case .loaded(var books) = state,
              let index = books.firstIndex(of: book) else { return }

        books[index].isFavorite.toggle()
        state = .loaded(data: books)
    }
    
    func navigateToDetail(book: Book) {
        path.append(BookRoute.detail(book))
    }

    var filteredBooks: [Book] {
        guard case .loaded(let books) = state else { return [] }
        guard !searchText.isEmpty else { return books }
        return books.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
}
