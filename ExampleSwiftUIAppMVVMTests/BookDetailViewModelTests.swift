import XCTest
@testable import ExampleSwiftUIAppMVVM

final class BookDetailViewModelTests: XCTestCase {
    func test_toggleFavorite() {
        let book = Book(title: "Swift", author: "Apple")
        let vm = BookDetailViewModel(book: book)

        XCTAssertFalse(vm.book.isFavorite)
        vm.toggleFavorite()
        XCTAssertTrue(vm.book.isFavorite)
    }
}
