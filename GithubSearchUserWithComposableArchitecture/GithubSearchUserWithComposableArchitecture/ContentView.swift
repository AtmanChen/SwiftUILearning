// 

import SwiftUI
import ComposableArchitecture
import ActivityIndicator
import SearchBar

struct GithubSearchUserError: Error, Equatable {}

struct GithubSearchUserState: Equatable {
  var query: String = ""
  var isRequestInFlight = false
  var repos: [Repo] = []
}

enum GithubSearchUserStateAction {
  case updateQuery(String)
  case usersResponse(Result<[Repo], GithubSearchUserError>)
}

struct GithubSearchUserEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  static let apiService = GithubService()
  var users: (String) -> Effect<[Repo], GithubSearchUserError>
  
  static let `default` = GithubSearchUserEnvironment(
    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
    users: GithubSearchUserEnvironment.apiService.search(matching:))
}

let githubSearchUserReducer = Reducer<
  GithubSearchUserState, GithubSearchUserStateAction, GithubSearchUserEnvironment
> { state, action, environment in
  switch action {
  case let .updateQuery(query):
    struct SearchUserId: Hashable {}
    state.query = query
    state.isRequestInFlight = true
    return environment
      .users(query)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .debounce(id: SearchUserId(), for: 0.3, scheduler: environment.mainQueue)
      .map(GithubSearchUserStateAction.usersResponse)
  case let .usersResponse(.success(repos)):
    state.isRequestInFlight = false
    state.repos = repos
    return .none
  case .usersResponse(.failure):
    state.isRequestInFlight = false
    return .none
  }
}
.debugActions()

struct ContentView: View {
  let store: Store<GithubSearchUserState, GithubSearchUserStateAction>
  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        List {
          SearchBar(
            text: viewStore.binding(
              get: { $0.query },
              send: GithubSearchUserStateAction.updateQuery
              ),
            placeHolder: "Type something...")
            .padding([.leading, .trailing], -8)
          if viewStore.isRequestInFlight {
            ActivityIndicator()
              .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
          } else {
            ForEach(viewStore.repos) { repo in
              RepoRow(repo: repo)
            }
          }
        }
        .navigationBarTitle("Search Users")
      }
    }
  }
}
