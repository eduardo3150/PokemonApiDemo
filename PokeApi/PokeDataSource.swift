import Foundation
import UIKit

class PokeDataSource: NSObject, UITableViewDataSource {
    private let pokemonNames: [String] = ["pikachu", "charizard", "bulbasaur", "lapras"]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = pokemonNames[indexPath.row].capitalized
        return cell
    }
    
    public func getPokemonNames() -> [String] {
        return pokemonNames
    }
}
