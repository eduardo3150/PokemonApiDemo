import Foundation

enum ResultType {
    case previous
    case next
}

typealias ButtonVisibility = (Bool, Bool)

protocol PokemonListPresenterProtocol {
    func loadInitialPokemonList()
    func fetchMoreResults(for type: ResultType)
    func updateFilteredView()
    func fetchPokemonWithQuery()
    func searchPokemonInList(with query: String)
}

protocol PokemonListViewProtocol: class {
    func refreshPokeCollectionView(with pokemonData: PokemonData)
    func enableButtonLoading(for buttonVisibility: ButtonVisibility)
    func showEmptyMessage()
    func hideEmptyMessage()
}

class PokemonListPresenter: PokemonListPresenterProtocol {
    var pokemonData: PokemonData = PokemonData.empty() {
        didSet {
            self.updateView()
        }
    }
    
    var originalPokemonData: PokemonData = PokemonData.empty()
    var pokemonQuery = ""
    
    let pokemonApi: HTTPRequestProvider = PokeApiProvider()

    weak var view: PokemonListViewProtocol?
    
    init(view: PokemonListViewProtocol) {
        self.view = view
    }
    
    func loadInitialPokemonList() {
        fetchPokemonList(with: nil)
    }

    func fetchMoreResults(for type: ResultType) {
        switch type {
        case .previous:
            fetchPokemonList(with: pokemonData.previous)
        case .next:
            fetchPokemonList(with: pokemonData.next)
        }
    }
    
    func searchPokemonInList(with query: String) {
        if originalPokemonData.results.isEmpty {
            self.originalPokemonData = self.pokemonData
        }
        self.pokemonData = PokemonData(
            next: originalPokemonData.next,
            previous: originalPokemonData.previous,
            results: originalPokemonData.results.filter({
                $0.name.uppercased() == query.uppercased()
            }))
        
        saveQuery(with: query)
    }
    
    func updateFilteredView() {
        if !originalPokemonData.results.isEmpty {
            self.pokemonData = originalPokemonData
            self.originalPokemonData = PokemonData.empty()
        }
    }
    
    func fetchPokemonWithQuery() {
        if !pokemonQuery.isEmpty {
            pokemonApi.getPokemonBy(name: pokemonQuery) { [weak self] pokemonInfo in
                guard let `self` = self,
                      let pokemonInfo = pokemonInfo else {  return }
                self.pokemonData = self.transformToPokemonData(using: pokemonInfo)
            }
        }
    }
    
    private func saveQuery(with pokemonName: String) {
        pokemonQuery = pokemonName
    }
    
    private func transformToPokemonData(using pokemonInfo: PokemonDetailInfo) -> PokemonData {
        return PokemonData(next: nil,
                           previous: nil,
                           results: [PokemonData.PokemonResult(name: pokemonInfo.name, url: "\(PokeApiProvider.baseURL)\(pokemonInfo.id)")])
    }

    private func fetchPokemonList(with url: String?) {
        pokemonApi.getPokemonList(with: url) { [weak self] pokemonData in
            guard let `self` = self,
                let pokemonData = pokemonData else {
                print("error loading data")
                return
            }
            self.pokemonData = pokemonData
        }
    }

    private func updateView() {
        view?.refreshPokeCollectionView(with: pokemonData)
        view?.enableButtonLoading(for: enableButtonForType(using: pokemonData))
        pokemonData.results.isEmpty ? view?.showEmptyMessage() : view?.hideEmptyMessage()
    }

    private func enableButtonForType(using pokemonData: PokemonData) -> ButtonVisibility {
        let previousResults: Bool = pokemonData.previous == nil
        let nextResults: Bool = pokemonData.next == nil
        return ButtonVisibility(previous: previousResults, next: nextResults) // Default value enables next result only
    }
}
