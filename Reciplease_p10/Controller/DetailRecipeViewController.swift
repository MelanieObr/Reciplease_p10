//
//  DetailRecipeViewController.swift
//  Reciplease_p10
//
//  Created by Mélanie Obringer on 12/12/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import UIKit

class DetailRecipeViewController: UIViewController {
    
    //MARK: - Properties
    
    var recipeDisplay: RecipeDisplay?
    var coreDataManager: CoreDataManager?
    
    //MARK: - Outlets
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var goDirectionButton: UIButton!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var goActivityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var ingredientDetailTableView: UITableView!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        manageActivityIndicator(activityIndicator: goActivityIndicator, button: goDirectionButton, showActivityIndicator: false)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
        updateTheView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateTheFavoriteIcon()
    }
}

// MARK: - Method

extension DetailRecipeViewController {
    
    /// update the View
    private func updateTheView() {
        recipeTitleLabel.text = recipeDisplay?.label
        recipeImageView.image = UIImage(data: recipeDisplay?.image ?? Data())
        yieldLabel.text = recipeDisplay?.yield
        totalTimeLabel.text = recipeDisplay?.totalTime
    }
}

// MARK: - CoreData

extension DetailRecipeViewController {
    
    /// update the favorite icon
    private func updateTheFavoriteIcon(){
        guard coreDataManager?.checkIfRecipeIsAlreadyFavorite(recipeName: recipeTitleLabel.text ?? "") == true else {
            favoriteButton.image = UIImage(named: "empty_heart")
            return }
        favoriteButton.image = UIImage(named: "full_heart")
    }
    
    /// adding recipes to coredata
    private func addRecipeToFavorites() {
        //            guard let recipeDisplay = recipeDisplay else { return } à revoir + optionnels RecipeDisplay
        guard let name = recipeDisplay?.label, let image = recipeDisplay?.image, let ingredients = recipeDisplay?.ingredients, let url = recipeDisplay?.url, let time = recipeDisplay?.totalTime, let yield = recipeDisplay?.yield else {return}
        coreDataManager?.addRecipeToFavorites(name: name, image: image, ingredientsDescription: ingredients, recipeUrl: url, time: time, yield: yield)
        
    }
}

// MARK: - Actions

extension DetailRecipeViewController {
    
    /// action after tapped Get Directions Button to open the url of the recipe
    @IBAction private func didTapGetDirectionsButton(_ sender: Any) {
        manageActivityIndicator(activityIndicator: goActivityIndicator, button: goDirectionButton, showActivityIndicator: true)
        guard let directionsUrl = URL(string: recipeDisplay?.url ?? "") else {return}
        UIApplication.shared.open(directionsUrl)
        manageActivityIndicator(activityIndicator: goActivityIndicator, button: goDirectionButton, showActivityIndicator: false)
    }
    
    /// action when favorite icon did tapped
    @IBAction private func didTapFavoriteButton(_ sender: UIBarButtonItem) {
        // when recipe isn't in favorite list to add it, alert user
        if sender.image == UIImage(named: "empty_heart") {
            sender.image = UIImage(named: "full_heart")
            alert(message: "Recipe added to your favorites list")
            addRecipeToFavorites()
            // when recipe is already added infavorite list to delete it, alert user
        } else if sender.image == UIImage(named: "full_heart") {
            sender.image = UIImage(named: "empty_heart")
            alert(message: "Recipe deleted from your favorites list")
            coreDataManager?.deleteRecipeFromFavorite(recipeName: recipeDisplay?.label ?? "")
        }
    }
}

//MARK: - TableViewDataSource

extension DetailRecipeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // print(recipeDisplay?.ingredients)
        return recipeDisplay?.ingredients.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipeDisplay = recipeDisplay else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsDetailCell", for: indexPath)
        let ingredient = recipeDisplay.ingredients[indexPath.row]
        cell.textLabel?.text = "- \(ingredient)"
        return cell
    }
}



