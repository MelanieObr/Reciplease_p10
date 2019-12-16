//
//  RecipeSession.swift
//  Reciplease_p10
//
//  Created by Mélanie Obringer on 10/12/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import Foundation
import Alamofire

//MARK: - Protocol AlamoSession and class SearchSession

protocol AlamoSession {
    func request(with url: URL, callBack: @escaping (DataResponse<Any>) -> Void)
}

final class SearchSession: AlamoSession {
    func request(with url: URL, callBack: @escaping (DataResponse<Any>) -> Void) {
        Alamofire.request(url).responseJSON { responseData in
            callBack(responseData)
        }
    }
}
