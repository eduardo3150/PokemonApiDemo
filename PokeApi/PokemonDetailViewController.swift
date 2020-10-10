import Foundation
import UIKit

class PokemonDetailViewController: UIViewController {


    @IBOutlet weak var pokeNameLabel: UILabel!
    @IBOutlet weak var pokeWeightLabel: UILabel!
    @IBOutlet weak var pokeAvatar: UIImageView!
    
    var pokemonName: String = ""
    var pokemonApi: HTTPRequestProvider?

    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonApi = PokeApiProvider()
        pokemonApi?.getPokemonBy(name: pokemonName) { [weak self] pokemonData in
            guard let `self` = self,
                let pokemonData = pokemonData else {  return }

            self.pokeNameLabel.text = pokemonData.name.capitalized
            self.pokeWeightLabel.text = self.calculateWeightInLbs(from: pokemonData.weight)
            if let url = URL(string: pokemonData.officialImage) {
                self.pokeAvatar.load(url: url)
            }
        }
    }

    private func calculateWeightInLbs(from hectograms: Int) -> String {
        let factor = 4.536 // 1 hectogram = 0.220462 pounds
        let conversion = Double(hectograms)/factor
        let weight = String(format: "%.01f", conversion)
        return "\(weight) lbs"
    }
}
