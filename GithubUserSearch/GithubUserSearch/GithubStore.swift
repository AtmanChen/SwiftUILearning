import Foundation
import SwiftUI
import Combine

protocol FluxAction {

}

protocol FluxReducer {
    associatedtype StateType: FluxState
    func reduce(state: StateType, action: FluxAction) -> StateType
}

protocol FluxState {

}


struct GithubUserActions {

    struct QueryUsers: FluxAction {
        init(querySyntax: String) {
            let _ = GithubAPIService.shared
                .search(username: querySyntax)
                .sink(
                  receiveCompletion: { _ in },
                  receiveValue: { users in
                    githubStore.dispatch(action: GithubUserActions.SetResultUsers(queryedUsers: users))
                })
        }
    }

    struct SetResultUsers: FluxAction {
        var queryedUsers: [GithubUser]
    }
}

struct GithubUserReducer: FluxReducer {
    typealias StateType = GithubUserState

    func reduce(state: GithubUserState, action: FluxAction) -> GithubUserState {
        var state = state
        if let action = action as? GithubUserActions.SetResultUsers {
            state.users = action.queryedUsers
        }
        return state
    }
}


struct GithubUserState: FluxState {
    var users: [GithubUser] = []
}

final class GithubStore: ObservableObject {

    var didChange = PassthroughSubject<GithubStore, Never>()

    var githubUserState: GithubUserState

    init(githubUserState: GithubUserState = GithubUserState()) {
        self.githubUserState = githubUserState
    }

    func dispatch(action: FluxAction) {
        githubUserState = GithubUserReducer().reduce(state: githubUserState, action: action)
        DispatchQueue.main.async {
            self.didChange.send(self)
        }
    }

}

let githubStore = GithubStore()
