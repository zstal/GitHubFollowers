import Foundation

enum PersistenceActionType {
    case add
    case remove
}

enum PersistenceManager {

    static private let defaults = UserDefaults.standard

    private enum Keys {
        static let favorites = "favorites"
    }

    static func update(with favorite: Follower,
                       actionType: PersistenceActionType,
                       completionHandler: @escaping (GFError?) -> Void) {

        retrieveFavorites { result in
            switch result {
            case .success(var favorites):

                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completionHandler(.alreadyInFavorites)
                        return
                    }
                    favorites.append(favorite)

                case .remove:
                    favorites.removeAll { $0.login == favorite.login }
                }

                completionHandler(save(favorites: favorites))

            case .failure(let error):
                completionHandler(error)
            }
        }

    }

    static func retrieveFavorites(completion: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favoritesData = defaults.data(forKey: Keys.favorites) else {
            // no saved data
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToRetrieveFavorites))
        }
    }

    static func save(favorites: [Follower]) -> GFError? {

        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
        } catch {
            return .unableToSaveFavorites
        }
        return nil
    }
}
