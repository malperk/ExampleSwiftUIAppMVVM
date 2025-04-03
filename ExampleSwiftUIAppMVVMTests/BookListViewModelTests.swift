import XCTest
@testable import ExampleSwiftUIAppMVVM

final class BookListViewModelTests: XCTestCase {

    class MockRepository: BookRepositoryProtocol {
        func fetchBooks() async throws -> [Book] {
            return [Book(title: "Test Book", author: "Test Author")]
        }
    }

    func test_loadBooks_success() async {
        let viewModel = BookListViewModel(repository: MockRepository())
        
        await viewModel.loadBooks()
        
        if case .loaded(let books) = viewModel.state {
            XCTAssertEqual(books.count, 1)
            XCTAssertEqual(books.first?.title, "Test Book")
        } else {
            XCTFail("Expected loaded state")
        }
    }

    func test_toggleFavorite() {
        let book = Book(title: "Test Book", author: "Author")
        let viewModel = BookListViewModel()
        viewModel.state = .loaded([book])

        viewModel.toggleFavorite(book: book)

        if case .loaded(let books) = viewModel.state {
            XCTAssertTrue(books.first?.isFavorite ?? false)
        } else {
            XCTFail("Expected loaded state")
        }
    }
}
