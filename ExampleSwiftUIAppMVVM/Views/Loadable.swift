enum Loadable<T: Equatable>: Equatable {
    case idle
    case loading
    case loaded(T)
    case failed(String)
}
