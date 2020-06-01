// 

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var state: GithubStore
  @State var searchUserName: String = ""
  
  var body: some View {
    NavigationView {
      List {
        TextField(
          "Search Github User",
          text: $searchUserName)
          .frame(height: 50)
          .background(Color.black.opacity(0.4))
          .foregroundColor(.white)
          .cornerRadius(4)
          .onReceive(
            NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)) { query in
              self.searchQuery()
          }
        ForEach(state.githubUserState.users) { user in
          GithubUserInfoRow(githubUser: user)
        }
      }.navigationBarTitle("Github Users")
    }
  }
  
  private func searchQuery() {
    githubStore.dispatch(action: GithubUserActions.QueryUsers(querySyntax: self.searchUserName))
  }
}

struct GithubUserInfoRow: View {
  var githubUser: GithubUser
  
  var body: some View {
    HStack {
      Image(systemName: "person.circle.fill")
        .clipShape(Circle())
      Text(githubUser.login)
      Spacer()
    }
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environmentObject(githubStore)
  }
}
