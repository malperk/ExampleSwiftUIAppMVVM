import Foundation

struct Book: Identifiable, Equatable, Hashable {
    let id: UUID
    let title: String
    let author: String
    var isFavorite: Bool

    init(id: UUID = UUID(), title: String, author: String, isFavorite: Bool = false) {
        self.id = id
        self.title = title
        self.author = author
        self.isFavorite = isFavorite
    }
}
