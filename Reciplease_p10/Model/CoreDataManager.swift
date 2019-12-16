//
//  CoreDataManager.swift
//  Reciplease_p10
//
//  Created by Mélanie Obringer on 14/12/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    

    // MARK: - Properties
    
    private let coreDataStack: CoreDataStack
    private let managedObjectContext: NSManagedObjectContext
    
    var favoritesRecipes: [FavoritesRecipesList] {
        let request: NSFetchRequest<FavoritesRecipesList> = FavoritesRecipesList.fetchRequest()
        guard let recipes = try? managedObjectContext.fetch(request) else { return [] }
        return recipes
    }
    
    // MARK: - Initializer
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.mainContext
    }
    
    // MARK: - Methods
    
    /// Manage  Favorite Recipes List entities
    func addRecipeToFavorites(name: String, image: Data, ingredientsDescription: String, recipeUrl: String, time: String) {
        let recipe = FavoritesRecipesList(context: managedObjectContext)
        recipe.image = image
        recipe.ingredients = ingredientsDescription
        recipe.name = name
        recipe.recipeUrl = recipeUrl
        recipe.totalTime = time
        coreDataStack.saveContext()
    }
    
    /// Delete recipe from favorite list
    func deleteRecipeFromFavorite(recipeName: String) {
        let request: NSFetchRequest<FavoritesRecipesList> = FavoritesRecipesList.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", recipeName)
        request.predicate = predicate
        if let objects = try? managedObjectContext.fetch(request) {
            objects.forEach { managedObjectContext.delete($0)}
        }
        coreDataStack.saveContext()
    }

    /// Delete all favorites in list
    func deleteAllFavorites() {
        favoritesRecipes.forEach { managedObjectContext.delete($0)}
        coreDataStack.saveContext()
    }
    
    /// Checking if a recipe is already saved in favorite list
    func checkIfRecipeIsAlreadyFavorite(recipeName: String) -> Bool {
        let request: NSFetchRequest<FavoritesRecipesList> = FavoritesRecipesList.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", recipeName)
        guard let recipes = try? managedObjectContext.fetch(request) else { return false }
        if recipes.isEmpty {return false}
        return true
    }
}
