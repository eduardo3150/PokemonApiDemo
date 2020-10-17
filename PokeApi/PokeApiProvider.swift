import Foundation
import Alamofire

struct PokemonDetailInfo: Decodable {
    let name: String
    let officialImage: String
    let weight: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case weight
        case sprites
        case other
        case officialArtwork = "official-artwork"
        case frontDefault = "front_default"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let spritesContainer = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .sprites)
        let otherSprites = try spritesContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .other)
        let officialArtwork = try otherSprites.nestedContainer(keyedBy: CodingKeys.self, forKey: .officialArtwork)

        name = try values.decode(String.self, forKey: .name)
        weight = try values.decode(Int.self, forKey: .weight)
        officialImage = try officialArtwork.decode(String.self, forKey: .frontDefault)
    }
}

struct PokemonData: Decodable {
    let next: String?
    let previous: String?
    let results: [PokemonResult]

    struct PokemonResult: Decodable {
        let name: String
        let url: String
    }
}

protocol HTTPRequestProvider {
    func getPokemonBy(name: String, completionHandler: @escaping (PokemonDetailInfo?)->())
    func getAllPokemons(completionHandler: @escaping (PokemonData?)->())
}

class PokeApiProvider: HTTPRequestProvider {
    let baseURL: String = "https://pokeapi.co/api/v2/pokemon/"
    
    func getPokemonBy(name: String, completionHandler: @escaping (PokemonDetailInfo?)->()) {
        AF.request("\(baseURL)\(name)", method: .get, encoding:  JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseData { response in
                
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let pokemonDetailInfo = try JSONDecoder().decode(PokemonDetailInfo.self, from: data)
                        completionHandler(pokemonDetailInfo)
                    } catch let error {
                        completionHandler(nil)
                        print(error)
                    }
                }
            case let .failure(error):
                completionHandler(nil)
                print(error)
            }
        }
    }
    
    func getAllPokemons(completionHandler: @escaping (PokemonData?) -> ()) {
        let url = "\(baseURL)?limit=150"
        
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                        completionHandler(pokemonData)
                    } catch let error {
                        print(error)
                    }
                case .failure(let error):
                    completionHandler(nil)
                    print(error)
                }
                
            }
    }
}
