import XCTest
@testable import HemnetLite

class PropertiesListViewModelTests: XCTestCase {
    
    func testFetchPropertiesList_successfull() {
        let service = PropertiesServiceMock(shouldReturnError: false)
        let expectation = XCTestExpectation(description: "List is fetched")

        service.fetchPropertiesList(completion: { result in
            switch result {
            case .failure(let error): XCTFail("Received an error: \(error.localizedDescription)")
            case .success(let list):
                XCTAssertNotNil(list)
                XCTAssertEqual(list.items.count, 2)
                XCTAssertEqual(list.items[0].type, .highlighted)
                XCTAssertEqual(list.items[1].type, .area)
                expectation.fulfill()
            }
        })

        wait(for: [expectation], timeout: 1)
    }

    func testFetchPropertiesList_recievedError() {
        let service = PropertiesServiceMock(shouldReturnError: true)
        let expectation = XCTestExpectation(description: "Received an error")

        service.fetchPropertiesList(completion: { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            case .success(let list): XCTFail("Received a list")
            }
        })

        wait(for: [expectation], timeout: 1)
    }
}

private struct PropertiesServiceMock: PropertiesService {
    var shouldReturnError: Bool
    let error = NSError(domain: "Service", code: 456, userInfo: nil)
    let propertiesList = PropertiesList(items: [Property(type: .highlighted,
                                                         id: "1234567890",
                                                         askingPrice: "30000 kr",
                                                         averagePrice: nil,
                                                         monthlyFee: "1 498 kr/mån",
                                                         municipality: "Stockholm kommun",
                                                         area: "Bromma",
                                                         daysOnHemnet: 1,
                                                         livingArea: 50,
                                                         numberOfRooms: 2,
                                                         streetAddress: "Mockvägen 1",
                                                         image: URL(string: "https://i.pinimg.com/564x/fd/47/3f/fd473f9622e2b8d1868a89db5897a02a.jpg")!),
                                                Property(type: .area,
                                                         id: "1234567892",
                                                         askingPrice: nil,
                                                         averagePrice: "32000 kr",
                                                         monthlyFee: nil,
                                                         municipality: nil,
                                                         area: "Stockholm",
                                                         daysOnHemnet: nil,
                                                         livingArea: nil,
                                                         numberOfRooms: nil,
                                                         streetAddress: nil,
                                                         image: URL(string: "https://i.pinimg.com/564x/fd/47/3f/fd473f9622e2b8d1868a89db5897a02a.jpg")!)
    ])

    func fetchPropertiesList(completion: @escaping (Result<PropertiesList, Error>) -> ()) {
        if shouldReturnError {
            completion(.failure(error))
        } else {
            completion(.success(propertiesList))
        }
    }
}
