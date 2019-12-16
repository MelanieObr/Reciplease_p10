//
//  SessionFake.swift
//  Reciplease_p10Tests
//
//  Created by Mélanie Obringer on 10/12/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

@testable import Reciplease_p10
import Foundation
import Alamofire

struct FakeResponse {
    var response: HTTPURLResponse?
    var data: Data?
}

final class FakeSession: AlamoSession {
    
    /// MARK: - Properties
    private let fakeResponse: FakeResponse
    
    /// MARK: - Initializer
    init(fakeResponse: FakeResponse) {
        self.fakeResponse = fakeResponse
    }
    
    func request(with url: URL, callBack: @escaping (DataResponse<Any>) -> Void) {
        let httpResponse = fakeResponse.response
        let data = fakeResponse.data
        
        let result = Request.serializeResponseJSON(options: .allowFragments, response: httpResponse, data: data, error: nil)
        let urlRequest = URLRequest(url: URL(string: "https://www.apple.com")!)
        callBack(DataResponse(request: urlRequest, response: httpResponse, data: data, result: result))
    }
}
