//
//  RecipesSearch.swift
//  Reciplease_p10
//
//  Created by Mélanie Obringer on 10/12/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import Foundation


//MARK: - Structures to manage data

//MARK: - RecipesSearch

struct RecipeSearch: Decodable {
    let hits: [Hit]
}

//MARK: - Hit

struct Hit: Decodable {
    let recipe: Recipe
}

//MARK: - Recipe

struct Recipe: Decodable {
    let label: String
    let image: String?
    let url: String
    let yield: Int?
    let ingredientLines: [String]
    let ingredients: [Ingredient]
    let totalTime: Int?
}

//MARK: - Ingredients

struct Ingredient: Decodable {
    let text: String
    let weight: Double
}

//MARK: - RecipeDisplay

struct RecipeDisplay {
    let label: String
    let image: Data?
    let url: String
    let ingredients: [String]
    let totalTime: String?
    let yield: String?
}
