// 

import Foundation

final class ReposStore: ObservableObject {
    
    @Published private(set) var repos: [Repo] = []
    private let service: GithubService
    
    init(service: GithubService) {
        self.service = service
    }
    func fetch(matching query: String) {
        self.service.search(matching: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(repos):
                    self?.repos = repos
                case .failure:
                    self?.repos = []
                }
            }
        }
    }
}
