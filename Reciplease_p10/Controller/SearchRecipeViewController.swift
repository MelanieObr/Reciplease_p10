//
//  SearchRecipeViewController.swift
//  Reciplease_p10
//
//  Created by Mélanie Obringer on 11/12/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import UIKit

class SearchRecipeViewController: UIViewController {
    
    //MARK: - Properties
    
    var ingredients: [String] = []
    let recipesService = RecipeService()
    var recipesSearch: RecipeSearch?
    let identifierSegue = "IngredientsToRecipes"
    
    //MARK: - Outlets
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var addIngredientButton: UIButton!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var searchRecipesButton: UIButton!
    @IBOutlet weak var searchActivityController: UIActivityIndicatorView!
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageActivityIndicator(activityIndicator: searchActivityController, button: searchRecipesButton, showActivityIndicator: false)
        
    }
    
    //MARK: - Configure segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recipesVC = segue.destination as? ListRecipeViewController {
            recipesVC.recipesSearch = recipesSearch
        }
    }
    
    //MARK: - Actions
    
    @IBAction func didTapButtonToAddIngredient(_ sender: Any) {
        if searchTextField.text != "" {
        guard let ingredient = searchTextField.text else { return }
        ingredients.append(ingredient)
        ingredientsTableView.reloadData()
        } else {
            alert(message: "write an ingredient and add it")
        }
    }
    
    @IBAction func didTapGoButton(_ sender: Any) {
        guard ingredients.count >= 1 else { return alert(message: "add an ingredient") }
        loadRecipes()
    }
    
    @IBAction func didTapClearButton(_ sender: Any) {
        ingredients.removeAll()
        ingredientsTableView.reloadData()
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchTextField.resignFirstResponder()
    }
    
    //MARK: - Methods
    
    func loadRecipes() {
        manageActivityIndicator(activityIndicator: searchActivityController, button: searchRecipesButton, showActivityIndicator: true)
        recipesService.getRecipes(ingredients: ingredients) { result in
            DispatchQueue.main.async {
                switch result {
                case.success(let recipes):
                    self.recipesSearch = recipes
//                    print(recipes) // test
                    self.performSegue(withIdentifier: self.identifierSegue, sender: nil)
                case .failure:
                    self.alert(message:"incorrect request")
                }
               self.manageActivityIndicator(activityIndicator: self.searchActivityController, button: self.searchRecipesButton, showActivityIndicator: false)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}

//MARK: - Extension TableView
extension SearchRecipeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? IngredientTableViewCell else {
            return UITableViewCell()
        }
        let ingredient = ingredients[indexPath.row]
        cell.configure(ingredient: ingredient)
        return cell
    }
}
