//
//  Reciplease_p10Tests.swift
//  Reciplease_p10Tests
//
//  Created by Mélanie Obringer on 10/12/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import XCTest
@testable import Reciplease_p10

class RecipleaseTests: XCTestCase {
    
    func testGetRecipes_WhenNoDataIsPassed_ThenShouldReturnFailedCallback() {
        let session = FakeSession(fakeResponse: FakeResponse(response: nil, data: nil))
        let requestService = RecipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes(ingredients: ["chicken"]) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getData method with no data failed.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipes_WhenIncorrectResponseIsPassed_ThenShouldReturnFailedCallback() {
        let session = FakeSession(fakeResponse: FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.correctData))
        let requestService = RecipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes(ingredients: ["chicken"]) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getData method with incorrect response failed.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipes_WhenUndecodableDataIsPassed_ThenShouldReturnFailedCallback() {
        let session = FakeSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData))
        let requestService = RecipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes(ingredients: ["chicken"]) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getData method with undecodable data failed.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipes_WhenCorrectDataIsPassed_ThenShouldReturnSuccededCallback() {
        let session = FakeSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.correctData))
        let requestService = RecipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes(ingredients: ["chicken"]) { result in
            guard case .success(let data) = result else {
                XCTFail("Test getData method with undecodable data failed.")
                return
            }
            XCTAssertTrue(data.hits[0].recipe.label == "Chicken Vesuvio")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
