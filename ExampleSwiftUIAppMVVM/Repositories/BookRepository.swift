import Foundation

protocol BookRepositoryProtocol {
    func fetchBooks() async throws -> [Book]
}

struct BookRepository: BookRepositoryProtocol {
    func fetchBooks() async throws -> [Book] {
        try await Task.sleep(nanoseconds: 1_000_000_000) // simulate delay
        
        if Bool.random() { // simulate error
            throw URLError(.badServerResponse)
        }
        
        return [
            Book(title: "Swift Programming", author: "Apple", isFavorite: true),
            Book(title: "Combine Essentials", author: "Point-Free"),
            Book(title: "iOS Animations", author: "John Sundell"),
        ]
    }
}
