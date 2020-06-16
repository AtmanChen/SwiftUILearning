// 

import Foundation

struct Repo: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String
    let description: String
}

struct SearchResponse: Decodable {
    let items: [Repo]
}
