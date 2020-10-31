import Foundation
import UIKit

protocol PokemonCollectionViewServiceDelegate: class {
    func didSelectPokemon(with name: String)
    func loadMorePokemons(with nextURL: String)
}

class PokemonCollectionViewService: NSObject {
    private var pokemonData: PokemonData?
    private var isLoading: Bool = false
    
    weak var delegate: PokemonCollectionViewServiceDelegate?

    public func setPokemonNames(pokemonNames: PokemonData, nextResults: Bool)  {
        if nextResults {
            self.pokemonData?.results.append(contentsOf: pokemonNames.results)
        } else {
            self.pokemonData = pokemonNames
        }
    }
}

extension PokemonCollectionViewService: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonData?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.cellId, for: indexPath) as? PokemonCell,
           let currentItem = pokemonData?.results[indexPath.row] {
            cell.configure(pokemonData: currentItem, imageId: indexPath.row + 1)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension PokemonCollectionViewService: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let pokemonName = pokemonData?.results[indexPath.row].name {
            self.delegate?.didSelectPokemon(with: pokemonName)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter,
           let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterCell.CELL_ID, for: indexPath) as? FooterCell {
            return cell
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter,
           let cell = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: FooterCell.CELL_ID, for: indexPath) as? FooterCell {
            cell.startAnimating()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter,
           let cell = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: FooterCell.CELL_ID, for: indexPath) as? FooterCell {
            cell.stopAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if currentOffset > 0 && maximumOffset - currentOffset <= 10.0 {
            if let nextUrl = pokemonData?.next {
                self.delegate?.loadMorePokemons(with: nextUrl)
            }
        }
    }
}
