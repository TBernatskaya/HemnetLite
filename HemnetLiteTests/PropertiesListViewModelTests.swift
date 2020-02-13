import XCTest
@testable import HemnetLite

class PropertiesListViewModelTests: XCTestCase {
    
    func testFetchPropertiesList_successfull() {
        let serviceMock = PropertiesServiceMock(shouldReturnError: false)
        let viewModel = PropertiesListViewModelImpl(service: serviceMock)
        let expectation = XCTestExpectation(description: "List is fetched")

        viewModel.fetchPropertiesList(completion: { list, error in
            XCTAssertNotNil(viewModel.list)
            XCTAssertNil(error)
            XCTAssertEqual(viewModel.list!.items.count, 2)
            XCTAssertEqual(viewModel.list!.items[0].type, .highlighted)
            XCTAssertEqual(viewModel.list!.items[1].type, .area)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)
    }

    func testFetchPropertiesList_recievedError() {
        let serviceMock = PropertiesServiceMock(shouldReturnError: true)
        let viewModel = PropertiesListViewModelImpl(service: serviceMock)
        let expectation = XCTestExpectation(description: "Received an error")

        viewModel.fetchPropertiesList(completion: { list, error in
            XCTAssertNil(viewModel.list)
            XCTAssertNotNil(error)
            expectation.fulfill()
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
                                                         rating: nil,
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
                                                         rating: "4.5/5",
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
