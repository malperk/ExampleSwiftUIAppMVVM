enum ViewState<Data: Equatable>: Equatable {
    case idle
    case loading
    case loaded(data: Data)
    case empty
    case failed(error: String)
}
