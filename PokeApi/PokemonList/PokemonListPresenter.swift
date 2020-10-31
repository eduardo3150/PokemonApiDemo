import Foundation

protocol PokemonListPresenterProtocol {
    func loadPokemonList(with nextUrl: String?)
}

protocol PokemonListViewProtocol: class {
    func refreshPokeCollectionView(with pokemonData: PokemonData, nextResults: Bool)
}

class PokemonListPresenter: PokemonListPresenterProtocol {
    
    let pokemonApi: HTTPRequestProvider = PokeApiProvider()

    weak var view: PokemonListViewProtocol?
    
    init(view: PokemonListViewProtocol) {
        self.view = view
    }
    
    func loadPokemonList(with nextUrl: String?) {
        pokemonApi.getPokemonList(nextPokemonUrl: nextUrl) { [weak self] pokemonData in
            guard let `self` = self,
                  let view = self.view,
                  let pokemonData = pokemonData else {
                print("error loading data")
                return
            }
            
            let hasNextResults = nextUrl != nil ? true : false
            view.refreshPokeCollectionView(with: pokemonData, nextResults: hasNextResults)
        }
    }
}
