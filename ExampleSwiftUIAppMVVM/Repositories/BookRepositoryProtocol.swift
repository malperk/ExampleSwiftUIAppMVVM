protocol BookRepositoryProtocol {
    func fetchBooksPage(page: Int) async throws -> [Book]
}
