import UIKit

class PokemonListViewController: UIViewController {
    
    @IBOutlet weak var pokeCollectionView: UICollectionView!
    
    let collectionViewService: PokemonCollectionViewService = PokemonCollectionViewService()

    lazy var presenter: PokemonListPresenterProtocol = PokemonListPresenter(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewService.delegate = self
        
        pokeCollectionView.register(UINib(nibName: "FooterCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterCell.CELL_ID)
        presenter.loadPokemonList(with: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPokemonInfo",
            let detailVC = segue.destination as? PokemonDetailViewController,
            let name = sender as? String {
            detailVC.pokemonName = name
        }
    }
    
    private func refeshTableView() {
        
    }
}

extension PokemonListViewController: PokemonCollectionViewServiceDelegate {
    func didSelectPokemon(with name: String) {
        self.performSegue(withIdentifier: "showPokemonInfo", sender: name)
    }
    
    func loadMorePokemons(with nextURL: String) {
        presenter.loadPokemonList(with: nextURL)
    }
}

extension PokemonListViewController: PokemonListViewProtocol {
    func refreshPokeCollectionView(with pokemonData: PokemonData, nextResults: Bool) {
        if !nextResults {
            self.pokeCollectionView.dataSource = collectionViewService
            self.pokeCollectionView.delegate = collectionViewService
        }
        self.collectionViewService.setPokemonNames(pokemonNames: pokemonData, nextResults: nextResults)
        self.pokeCollectionView.collectionViewLayout.invalidateLayout()
        self.pokeCollectionView.reloadData()
    }
}
