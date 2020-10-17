import Foundation
import UIKit
import SDWebImage

class PokemonCell: UICollectionViewCell {
    static let cellId = "pokemonCell"
    
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var cardContainer: UIView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(pokemonData: PokemonData.PokemonResult, imageId: Int) {
        pokemonName.text = pokemonData.name.capitalized
        pokemonImage.sd_setImage(with: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(imageId).png"))
        
        setCardStyle()
    }
    
    private func setCardStyle() {
        cardContainer.layer.cornerRadius = 15.0
        cardContainer.layer.shadowColor = UIColor.gray.cgColor
        cardContainer.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cardContainer.layer.shadowRadius = 4.0
        cardContainer.layer.shadowOpacity = 0.7
    }
}
