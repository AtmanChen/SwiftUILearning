// 

import SwiftUI

struct RepoRow: View {
    let repo: Repo
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.repo.name)
                .font(.headline)
            Text(self.repo.description)
                .font(.subheadline)
        }
    }
}
