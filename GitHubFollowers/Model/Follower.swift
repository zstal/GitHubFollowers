import Foundation

struct Follower: Codable {
    let login: String
    let avatarUrl: String // no need for optional, GitHub will generate default one
}

extension Follower: Hashable {}
