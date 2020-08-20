import UIKit

class NetworkManager {

    static let shared = NetworkManager()
    private let baseUrl = "https://api.github.com/"
    let cache = NSCache<NSString, UIImage>()

    private init() {
        // disable instantiation from the outside
    }

    func getFollowers(for username: String,
                      page: Int,
                      completionHandler: @escaping (Result<[Follower], GFError>) -> Void) {
        let endpoint = baseUrl + "users/\(username)/followers?per_page=100&page=\(page)"

        guard let url = URL(string: endpoint) else {
            completionHandler(.failure(.invalidUsername))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(.unableToComplete))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completionHandler(.success(followers))
            } catch {
                completionHandler(.failure(.invalidData))
            }
        }
        task.resume()
    }

    func getUserInfo(for username: String,
                     completionHandler: @escaping (Result<User, GFError>) -> Void) {
        let endpoint = baseUrl + "users/\(username)"

        guard let url = URL(string: endpoint) else {
            completionHandler(.failure(.invalidUsername))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(.unableToComplete))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let user = try decoder.decode(User.self, from: data)
                completionHandler(.success(user))
            } catch {
                completionHandler(.failure(.invalidData))
            }
        }
        task.resume()
    }

    func downloadImage(from urlString: String, completionHandler: @escaping (UIImage?) -> Void) {
        // check cache before starting a download
        if let image = cache.object(forKey: urlString as NSString) {
            completionHandler(image)
            return
        }

        // no need for error messaging - there's a placeholder image
        guard let url = URL(string: urlString) else {
            completionHandler(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data)
            else {
                completionHandler(nil)
                return
            }

            // store downloaded image in cache
            self.cache.setObject(image, forKey: urlString as NSString)
            completionHandler(image)
        }.resume()
    }
}
