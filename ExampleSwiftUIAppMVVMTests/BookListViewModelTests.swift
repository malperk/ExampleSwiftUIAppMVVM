import XCTest
@testable import ExampleSwiftUIAppMVVM

final class BookListViewModelTests: XCTestCase {

    class MockRepo: BookRepositoryProtocol {
        var pages: [[Book]] = [
            [Book(title: "A", author: "1"), Book(title: "B", author: "2"), Book(title: "C", author: "3")],
            [Book(title: "D", author: "4")]
        ]

        private var currentPage = 0

        func fetchBooksPage(page: Int) async throws -> [Book] {
            guard page - 1 < pages.count else { return [] }
            defer { currentPage += 1 }
            return pages[currentPage]
        }
    }

    func test_pagination() async {
        let vm = BookListViewModel(repository: MockRepo())

        await vm.loadBooks(reset: true)
        XCTAssertEqual(vm.filteredBooks.count, 3)

        await vm.loadBooks()
        XCTAssertEqual(vm.filteredBooks.count, 4)

        await vm.loadBooks()
        XCTAssertEqual(vm.filteredBooks.count, 4) // no more data
    }

    func test_navigation() {
        let vm = BookListViewModel()
        let book = Book(title: "Test", author: "Test")
        vm.state = .loaded(data: [book])
        vm.navigateToDetail(book: book)
        XCTAssertEqual(vm.path.count, 1)
    }
}
