import Foundation

protocol BookRepositoryProtocol {
    func fetchBooksPage(page: Int) async throws -> [Book]
}

struct BookRepository: BookRepositoryProtocol {
    func fetchBooksPage(page: Int) async throws -> [Book] {
        try await Task.sleep(nanoseconds: 500_000_000) // faster simulate

        if Bool.random() { // simulate error
            throw URLError(.badServerResponse)
        }

        // Simulated paginated data
        return (1...3).map { index in
            Book(title: "Book \(index + (page - 1) * 3)", author: "Author \(index)")
        }
    }
}
