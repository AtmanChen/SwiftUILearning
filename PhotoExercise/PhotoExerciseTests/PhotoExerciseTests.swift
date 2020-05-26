// 

import XCTest
@testable import PhotoExercise

class PhotoExerciseTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let photo = Photo(id: "1009", author: "good", width: 600, height: 500, url: "https://photo/id/1009/600/500", downloadUrl: "https://photo/id/1009/600/500")
        assert(photo.plainDownloadUrlString == "https://photo/id/1009", "plainDownloadUrlString")
        
//        assert(photo.resizeDownloadUrl(width: 40, height: 40).absoluteString == "https://photo/id/1009/40/40", "resizeDownloadUrl")
        
        
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
