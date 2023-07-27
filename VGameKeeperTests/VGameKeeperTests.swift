//
//  VGameKeeperTests.swift
//  VGameKeeperTests
//
//  Created by Manuel Gonzalez on 26/07/23.
//

import XCTest

final class VGameKeeperTests: XCTestCase {

    var gamesViewModel: DiscoverViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        print("Setup()")
        gamesViewModel = DiscoverViewModel(gameQueries: TestGameQueries())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        gamesViewModel = nil
    }

    
    func testGameReleases() {
        let expectation = XCTestExpectation(description: "Fetch all discoveries")
        gamesViewModel.fetchDiscoveries {
            expectation.fulfill()
        }
        wait(for: [expectation])
        XCTAssertNotNil(gamesViewModel.discoveries, "Expected Discoveries not nil")
    }

}
