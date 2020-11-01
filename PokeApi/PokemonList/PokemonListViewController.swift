import UIKit

class PokemonListViewController: UIViewController {
    
    @IBOutlet weak var pokeCollectionView: UICollectionView!
    @IBOutlet weak var previousResultsButton: UIButton!
    @IBOutlet weak var nextResultsButton: UIButton!
    
    let pokeDataSource: PokeDataSource = PokeDataSource()

    lazy var presenter: PokemonListPresenterProtocol = PokemonListPresenter(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokeCollectionView.dataSource = pokeDataSource
        pokeCollectionView.delegate = self
        presenter.loadInitialPokemonList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPokemonInfo",
            let detailVC = segue.destination as? PokemonDetailViewController,
            let name = sender as? String {
            detailVC.pokemonName = name
        }
    }
    @IBAction func didSelectPreviousResults(_ sender: Any) {
        presenter.fetchMoreResults(for: .previous)
    }
    @IBAction func didSelectNextResults(_ sender: Any) {
        presenter.fetchMoreResults(for: .next)
    }
}

extension PokemonListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let pokemonName = pokeDataSource.getPokemonNames()[indexPath.row].name
        self.performSegue(withIdentifier: "showPokemonInfo", sender: pokemonName)
    }
}

extension PokemonListViewController: PokemonListViewProtocol {
    func enableButtonLoading(for buttonVisibility: ButtonVisibility) {
        previousResultsButton.isHidden = buttonVisibility.0
        nextResultsButton.isHidden = buttonVisibility.1
    }

    func refreshPokeCollectionView(with pokemonData: PokemonData) {
        self.pokeDataSource.setPokemonNames(pokemonNames: pokemonData.results)
        self.pokeCollectionView.reloadData()
    }
}
