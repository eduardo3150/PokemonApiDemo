import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pokeCollectionView: UICollectionView!
    
    let pokeDataSource: PokeDataSource = PokeDataSource()
    var pokemonApi: HTTPRequestProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pokemonApi = PokeApiProvider()
        pokemonApi?.getAllPokemons { [weak self] pokemonData in
            guard let `self` = self, let pokemonData = pokemonData else { return }
            self.pokeDataSource.setPokemonNames(pokemonNames: pokemonData.results)
            self.pokeCollectionView.reloadData()
        }
        
        pokeCollectionView.dataSource = pokeDataSource
        pokeCollectionView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPokemonInfo",
            let detailVC = segue.destination as? PokemonDetailViewController,
            let name = sender as? String {
            detailVC.pokemonName = name
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let pokemonName = pokeDataSource.getPokemonNames()[indexPath.row].name
        self.performSegue(withIdentifier: "showPokemonInfo", sender: pokemonName)
    }
}
