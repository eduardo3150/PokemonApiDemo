import Foundation
import UIKit

class PokeDataSource: NSObject, UICollectionViewDataSource {
    private var pokemonNames: [PokemonData.PokemonResult] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.cellId, for: indexPath) as? PokemonCell {
            let currentItem = pokemonNames[indexPath.row]
            let imageId = getImageIdFromURL(currentItem: currentItem)
            cell.configure(pokemonData: currentItem, imageId: imageId)
            return cell
        }
        return UICollectionViewCell()
    }
    
    public func getPokemonNames() -> [PokemonData.PokemonResult] {
        return pokemonNames
    }
    
    public func setPokemonNames(pokemonNames: [PokemonData.PokemonResult])  {
        self.pokemonNames = pokemonNames
    }

    private func getImageIdFromURL(currentItem: PokemonData.PokemonResult) -> Int {
        var url = currentItem.url.split(separator: "/")
        if let lastElement = url.popLast() {
            let lastElementStr = String(lastElement)
            return Int(lastElementStr) ?? 0
        }
        return 0
    }
}
