import Foundation
import Alamofire

struct PokemonData {
    let name: String
    let officialImage: String
    let weight: Int
}

protocol HTTPRequestProvider {
    func getPokemonBy(name: String, completionHandler: @escaping (PokemonData?)->())
}

class PokeApiProvider: HTTPRequestProvider {
    let baseURL: String = "https://pokeapi.co/api/v2/pokemon/"
    
    func getPokemonBy(name: String, completionHandler: @escaping (PokemonData?)->()) {
        AF.request("\(baseURL)\(name)", method: .get, encoding:  JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseData { [weak self] response in
                
            switch response.result {
            case .success:
                if let data = response.data,
                    let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] {

                    let pokemonData = self?.parseJsonResult(jsonResult: jsonResult)
                    completionHandler(pokemonData)
                }
            case let .failure(error):
                completionHandler(nil)
                print(error)
            }
        }
    }
    
    private func parseJsonResult(jsonResult: [String: Any]) -> PokemonData? {
        if  let pokemonName = jsonResult["name"] as? String,
            let pokemonWeight = jsonResult["weight"] as? Int,
            let spritesDict  = jsonResult["sprites"] as? [String: Any],
            let otherArtworkDict = spritesDict["other"] as? [String: Any],
            let officialArtworkDict = otherArtworkDict["official-artwork"] as? [String: Any],
            let officialArtwork = officialArtworkDict["front_default"] as? String {
            
            return PokemonData(name: pokemonName, officialImage: officialArtwork, weight: pokemonWeight)
        }
        return nil
    }
}
