// 

import SwiftUI
import Combine

struct SearchView: View {
    @State var query: String = "Swift"
    @EnvironmentObject var reposStore: ReposStore
    
    var body: some View {
        NavigationView {
            List {
                TextField("Type something...", text: $query, onCommit: fetch)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                ForEach(self.reposStore.repos) { repo -> RepoRow in
                    RepoRow(repo: repo)
                }
            }.navigationBarTitle("Search")
        }.onAppear(perform: fetch)
    }
    
    private func fetch() {
        self.reposStore.fetch(matching: self.query)
    }
}
