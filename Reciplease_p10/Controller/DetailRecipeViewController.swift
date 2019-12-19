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
    @IBOutlet weak var recipeIngredientsTextView: UITextView!
    @IBOutlet weak var goDirectionButton: UIButton!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    
    @IBOutlet weak var goActivityIndicator: UIActivityIndicatorView!
    
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
    
    /// Update the View
    private func updateTheView() {
        recipeTitleLabel.text = recipeDisplay?.label
        recipeImageView.image = UIImage(data: recipeDisplay?.image ?? Data())
        recipeIngredientsTextView.text = recipeDisplay?.ingredientLines
        yieldLabel.text = recipeDisplay?.yield
         guard recipeDisplay?.totalTime != "0mn" else {
                       totalTimeLabel.text = "NA"
                       return
                   }
                   totalTimeLabel.text = recipeDisplay?.totalTime
               }
    }


// MARK: - CoreData
extension DetailRecipeViewController {
    
    /// Update the favorite icon
    private func updateTheFavoriteIcon(){
        guard coreDataManager?.checkIfRecipeIsAlreadyFavorite(recipeName: recipeTitleLabel.text ?? "") == true else {
            favoriteButton.image = UIImage(named: "empty_heart")
            return }
        favoriteButton.image = UIImage(named: "full_heart")
    }
    
    /// Adding recipes to coredata
    private func addRecipeToFavorites() {
        //            guard let recipeDisplay = recipeDisplay else { return } à revoir + optionnels RecipeDisplay
        guard let name = recipeDisplay?.label, let image = recipeDisplay?.image, let ingredients = recipeDisplay?.ingredientLines, let url = recipeDisplay?.url, let time = recipeDisplay?.totalTime, let yield = recipeDisplay?.yield else {return}
        coreDataManager?.addRecipeToFavorites(name: name, image: image, ingredientsDescription: ingredients, recipeUrl: url, time: time, yield: yield)
    }
}

// MARK: - Actions
extension DetailRecipeViewController {
    
    /// Action after tapped Get Directions Button to open the url of the recipe
    @IBAction private func didTapGetDirectionsButton(_ sender: Any) {
        manageActivityIndicator(activityIndicator: goActivityIndicator, button: goDirectionButton, showActivityIndicator: true)
        guard let directionsUrl = URL(string: recipeDisplay?.url ?? "") else {return}
        UIApplication.shared.open(directionsUrl)
        manageActivityIndicator(activityIndicator: goActivityIndicator, button: goDirectionButton, showActivityIndicator: false)
    }
    
    /// Action when favorite icon did tapped
        @IBAction private func didTapFavoriteButton(_ sender: UIBarButtonItem) {
            if sender.image == UIImage(named: "empty_heart") {
                sender.image = UIImage(named: "full_heart")
                alert(message: "Recipe added to your favorites list")
                addRecipeToFavorites()
                
            } else if sender.image == UIImage(named: "full_heart") {
                sender.image = UIImage(named: "empty_heart")
                alert(message: "Recipe deleted from your favorites list")
                coreDataManager?.deleteRecipeFromFavorite(recipeName: recipeDisplay?.label ?? "")
                
            }
        }
}

