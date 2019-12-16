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
    @IBOutlet weak var favoritesIconButton: UIBarButtonItem!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    
    @IBOutlet weak var goActivityIndicator: UIActivityIndicatorView!
    
     override func viewDidLoad() {
            super.viewDidLoad()
        manageActivityIndicator(activityIndicator: goActivityIndicator, button: goDirectionButton, showActivityIndicator: false)
           recipeIngredientsTextView.isEditable = false
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let coreDataStack = appDelegate.coreDataStack
            coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
            updateTheView()
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            recipeIngredientsTextView.contentOffset = .zero
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
        }
    }

    // MARK: - Properties
    extension DetailRecipeViewController {
        
        /// Update the View
        private func updateTheView() {
            recipeTitleLabel.text = recipeDisplay?.label
            recipeImageView.image = UIImage(data: recipeDisplay?.image ?? Data())
            recipeIngredientsTextView.text = recipeDisplay?.ingredientLines
            totalTimeLabel.text = recipeDisplay?.totalTime
            yieldLabel.text = convertToString(value: recipeDisplay!.yield)
        }
    }

    // MARK: - CoreData
    extension DetailRecipeViewController {
    
        
        /// Adding recipes to coredata
        
        private func addRecipeToFavorites() {
            guard let name = recipeDisplay?.label, let image = recipeDisplay?.image, let ingredients = recipeDisplay?.ingredientLines, let url = recipeDisplay?.url, let time = recipeDisplay?.totalTime else {return}
            coreDataManager?.addRecipeToFavorites(name: name, image: image, ingredientsDescription: ingredients, recipeUrl: url, time: time)
        }
    }

    // MARK: - Actions
    extension DetailRecipeViewController {
        
        /// Action after typing the Get Directions Button
        @IBAction private func didTapGetDirectionsButton(_ sender: Any) {
            manageActivityIndicator(activityIndicator: goActivityIndicator, button: goDirectionButton, showActivityIndicator: true)
            guard let directionsUrl = URL(string: recipeDisplay?.url ?? "") else {return}
            UIApplication.shared.open(directionsUrl)
        }
        
        /// Action after typing the favorite icon
        @IBAction private func didTapFavoriteButton(_ sender: UIBarButtonItem) {
        
                addRecipeToFavorites()
            alert(message: "recipe added to your favorites")
        }
}
