//
//  FavoriteRecipeViewController.swift
//  Reciplease_p10
//
//  Created by Mélanie Obringer on 11/12/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import UIKit

final class FavoriteRecipeViewController: UIViewController {
    
    
    // MARK: - Variables
    private var recipeDisplay: RecipeDisplay?
    private var coreDataManager: CoreDataManager?
    
    // MARK: - Outlets
    @IBOutlet private weak var favoriteRecipeTableView: UITableView! { didSet { favoriteRecipeTableView.tableFooterView = UIView() }}
    @IBOutlet private var clearButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        favoriteRecipeTableView.register(nibName, forCellReuseIdentifier: "recipeCell")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favoriteRecipeTableView.reloadData()
        guard coreDataManager?.favoritesRecipes.count == 0 else {
            navigationItem.rightBarButtonItem = clearButton
            return
        }
        navigationItem.rightBarButtonItem = nil
    }
    
    // MARK: - Segue
    /// Segue to RecipeDetailsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "FavoritesListToDetail" else {return}
        guard let recipesVc = segue.destination as? DetailRecipeViewController else {return}
        recipesVc.recipeDisplay = recipeDisplay
    }
    
    // MARK: - Action
    @IBAction private func didTapClearButton(_ sender: Any) {
        navigationItem.rightBarButtonItem = nil
        alert(message: "delete all favorites")
        coreDataManager?.deleteAllFavorites()
        favoriteRecipeTableView.reloadData()
    }
}

// MARK: - TableView DataSource
extension FavoriteRecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager?.favoritesRecipes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        cell.favoriteRecipe = coreDataManager?.favoritesRecipes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoriteRecipe = coreDataManager?.favoritesRecipes[indexPath.row]
        let recipeDisplay = RecipeDisplay(label: favoriteRecipe?.name, image: favoriteRecipe?.image, url: favoriteRecipe?.recipeUrl, ingredientLines: favoriteRecipe?.ingredients, totalTime: favoriteRecipe?.totalTime, yield: favoriteRecipe?.yield)
            self.recipeDisplay = recipeDisplay
            self.performSegue(withIdentifier: "FavoritesListToDetail", sender: nil)
    }
   
}

// MARK: - TableView Delegate
extension FavoriteRecipeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return coreDataManager?.favoritesRecipes.isEmpty ?? true ? tableView.bounds.size.height : 0
    }
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 140 // the height for custom cell 0
   }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let recipeName = coreDataManager?.favoritesRecipes[indexPath.row].name else {return}
        coreDataManager?.deleteRecipeFromFavorite(recipeName: recipeName)
        favoriteRecipeTableView.reloadData()
        guard coreDataManager?.favoritesRecipes.isEmpty == true else {
            navigationItem.rightBarButtonItem = clearButton
            return
        }
        navigationItem.rightBarButtonItem = nil
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let translation = CATransform3DTranslate(CATransform3DIdentity,0,120,0)
        cell.layer.transform = translation
        cell.alpha = 0
        UIView.animate(withDuration: 0.75){
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1
        }
    }
}
       
