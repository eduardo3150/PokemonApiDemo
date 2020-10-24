import Foundation

protocol PokemonListPresenterProtocol {
    func loadInitialPokemonList()
}

protocol PokemonListViewProtocol: class {
    func refreshPokeCollectionView(with pokemonData: PokemonData)
}

class PokemonListPresenter: PokemonListPresenterProtocol {
    
    let pokemonApi: HTTPRequestProvider = PokeApiProvider()

    weak var view: PokemonListViewProtocol?
    
    init(view: PokemonListViewProtocol) {
        self.view = view
    }
    
    func loadInitialPokemonList() {
        pokemonApi.getAllPokemons { [weak self] pokemonData in
            guard let `self` = self,
                  let view = self.view,
                  let pokemonData = pokemonData else {
                print("error loading data")
                return
            }
            view.refreshPokeCollectionView(with: pokemonData)
        }
    }
}
