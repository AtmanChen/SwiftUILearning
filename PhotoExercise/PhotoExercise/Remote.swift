// 

import Foundation
import Combine
import UIKit

struct RequestError: Error {}

struct Photo: Decodable, Identifiable {
    let id: String
    let author: String
    let width: Double
    let height: Double
    let url: String
    let downloadUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case width
        case height
        case url
        case downloadUrl = "download_url"
    }
}

extension Photo {
    var plainDownloadUrlString: String {
        var downloadUrlComponents = self.downloadUrl.components(separatedBy: "/")
        downloadUrlComponents.removeLast(2)
        let plainDownloadUrl = downloadUrlComponents.joined(separator: "/")
        return plainDownloadUrl
    }
    
    var previewDownloadUrl: URL {
        resizeDownloadUrl(width: 40, height: 40)
    }
    
    private func resizeDownloadUrl(width: Int, height: Int) -> URL {
        let resizeDownloadUrlString = plainDownloadUrlString + "/\(width)" + "/\(height)"
        return URL(string: resizeDownloadUrlString)!
    }
}

final class Remote<T>: ObservableObject {
    
    @Published var result: Result<T, RequestError>?
    @Published var isLoading: Bool = false
    var value: T? { try? result?.get() }
    
    private let url: URL
    private let transform: (Data) -> T?
    private let db = Database()
    
    init(url: URL, transform: @escaping (Data) -> T?) {
        self.url = url
        self.transform = transform
    }
    
    func load() {
        let key = self.url.absoluteString.replacingOccurrences(of: "/", with: ".").replacingOccurrences(of: ":", with: "")
        if let image = db.retrieveData(for: key) {
            DispatchQueue.main.async {
                self.result = .success(image as! T)
                return
            }
        }
        self.isLoading = true
        URLSession.shared.dataTask(with: self.url) { (data, _, _) in
            DispatchQueue.main.async {
                self.isLoading = false
                if let data = data, let v = self.transform(data) {
                    if v is UIImage {
                        self.db.save(data: (v as! UIImage).pngData() ?? Data(), for: key)
                    }
                    self.result = .success(v)
                } else {
                    self.result = .failure(RequestError())
                }
            }
        }.resume()
    }
}

final class Database {
    
    private func filePath(for key: String) -> URL? {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentUrl.appendingPathComponent(key)
    }
    
    func save(data: Data, for key: String) {
        guard let filePath = filePath(for: key) else {
            return
        }
        let fileExists = FileManager.default.fileExists(atPath: filePath.path)
        guard !fileExists else {
            return
        }
        try? data.write(to: filePath, options: .atomic)
    }
    
    func retrieveData(for key: String) -> UIImage? {
        guard let filePath = filePath(for: key), let data = FileManager.default.contents(atPath: filePath.path) else {
            return nil
        }
        return UIImage(data: data)
    }   
}
