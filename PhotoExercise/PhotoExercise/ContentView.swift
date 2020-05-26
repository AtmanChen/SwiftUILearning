// 

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var items = Remote(
    url: URL(string: "https://picsum.photos/v2/list")!,
    transform: { try? JSONDecoder().decode([Photo].self, from: $0) })
    
    var body: some View {
        NavigationView {
            if items.value == nil {
                Text("Loading...")
                    .onAppear { self.items.load() }
            } else {
                List {
                    ForEach(items.value!) { photo in
                        PhotoPreviewCell(photo: photo)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PhotoPreviewCell: View {

    @ObservedObject var item: Remote<UIImage>
    private(set) var photo: Photo

    init(photo: Photo) {
        self.photo = photo
        self.item = Remote(url: photo.previewDownloadUrl, transform: { UIImage(data: $0)! })
    }
    
    var body: some View {
        HStack {
            if item.value == nil {
                ActivityIndicator(shouldAnimate: self.item.isLoading)
            } else {
                Image(uiImage: item.value!)
                    .resizable()
                    .frame(width: 44, height: 44)
            }
            Text(self.photo.author)
                .onAppear { self.item.load() }
        }
    }

}
