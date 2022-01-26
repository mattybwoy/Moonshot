//
//  MoonshotTests.swift
//  MoonshotTests
//
//  Created by Matthew Lock on 20/01/2022.
//

import XCTest
@testable import Moonshot

class MoonshotTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_loadCoins_WhenSucessfulResponse_ReturnsSucess() throws {
        //Arrange
        let sut = DataManager()
        let baseURL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency="
        
        //Act
//        sut.loadCoins { [Coins].self, error
//            <#code#>
//        }
        //Assert
        
    }

}
