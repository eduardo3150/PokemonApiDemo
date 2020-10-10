import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pokeTableView: UITableView!
    
    let pokeDataSource: PokeDataSource = PokeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pokeTableView.dataSource = pokeDataSource
        pokeTableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPokemonInfo",
            let detailVC = segue.destination as? PokemonDetailViewController,
            let name = sender as? String {
            detailVC.pokemonName = name
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pokemonName = pokeDataSource.getPokemonNames()[indexPath.row]
        self.performSegue(withIdentifier: "showPokemonInfo", sender: pokemonName)
    }
}
