import Combine

class BookDetailViewModel: ObservableObject {
    @Published var book: Book

    init(book: Book) {
        self.book = book
    }

    func toggleFavorite() {
        book.isFavorite.toggle()
    }
}
