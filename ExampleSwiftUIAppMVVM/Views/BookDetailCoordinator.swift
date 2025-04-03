import SwiftUI

struct BookDetailCoordinator: View {
    let book: Book

    var body: some View {
        BookDetailView(viewModel: BookDetailViewModel(book: book))
    }
}
