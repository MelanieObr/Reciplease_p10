//
//  RecipesService.swift
//  Reciplease_p10
//
//  Created by Mélanie Obringer on 10/12/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import Foundation

final class RecipeService {
    
    //MARK: - Properties
    
    var searchData = [RecipeSearch]()
    private let session: AlamoSession
    
    //MARK: - Initializer
    
    init(session: AlamoSession = SearchSession()) {
        self.session = session
    }
    
    //MARK: - Method
    
    /// Method to send request with the API
    func getRecipes(ingredients: [String], callback: @escaping (Result<RecipeSearch, ErrorCases>) -> Void) {
        guard let url = URL(string: "https://api.edamam.com/search?q=\(ingredients.joined(separator: ","))&to=100&app_id=\(ApiConfig.apiId)&app_key=\(ApiConfig.apiKey)") else { return }
        session.request(with: url) { responseData in
            guard let data = responseData.data else {
                print ("no data")
                callback(.failure(.errorNetwork))
                return
            }
            guard responseData.response?.statusCode == 200 else {
                print ("bad status code")
                callback(.failure(.invalidRequest))
                return
            }
            guard let responseJSON = try? JSONDecoder().decode(RecipeSearch.self, from: data) else {
                print ("no json")
                callback(.failure(.errorDecode))
                return
            }
            callback(.success(responseJSON))
            self.searchData = [responseJSON]
            
        }
    }
}

