import Foundation

enum ResultType {
    case previous
    case next
}

typealias ButtonVisibility = (Bool, Bool)

protocol PokemonListPresenterProtocol {
    func loadInitialPokemonList()
    func fetchMoreResults(for type: ResultType)
}

protocol PokemonListViewProtocol: class {
    func refreshPokeCollectionView(with pokemonData: PokemonData)
    func enableButtonLoading(for buttonVisibility: ButtonVisibility)
}

class PokemonListPresenter: PokemonListPresenterProtocol {
    var pokemonData: PokemonData = PokemonData.empty() {
        didSet {
            self.updateView()
        }
    }
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
    }

    private func enableButtonForType(using pokemonData: PokemonData) -> ButtonVisibility {
        let previousResults: Bool = pokemonData.previous == nil
        let nextResults: Bool = pokemonData.next == nil
        return ButtonVisibility(previous: previousResults, next: nextResults) // Default value enables next result only
    }
}
