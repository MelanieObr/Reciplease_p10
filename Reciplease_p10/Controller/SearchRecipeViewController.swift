//
//  SearchRecipeViewController.swift
//  Reciplease_p10
//
//  Created by Mélanie Obringer on 11/12/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import UIKit

final class SearchRecipeViewController: UIViewController {
    
    //MARK: - Properties
    
    var ingredients: [String] = []
    let recipesService = RecipeService()
    var recipesSearch: RecipeSearch?
    let identifierSegue = "IngredientsToRecipes"
    
    //MARK: - Outlets
    
    @IBOutlet weak private var searchTextField: UITextField!
    @IBOutlet weak private var addIngredientButton: UIButton!
    @IBOutlet weak private var ingredientsTableView: UITableView!
    @IBOutlet weak private var searchRecipesButton: UIButton!
    @IBOutlet weak private var searchActivityController: UIActivityIndicatorView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageActivityIndicator(activityIndicator: searchActivityController, button: searchRecipesButton, showActivityIndicator: false)
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: "tap:")
        view.addGestureRecognizer(tapGestureReconizer)
    }
    
    //MARK: - Configure segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recipesVC = segue.destination as? ListRecipeViewController {
            recipesVC.recipesSearch = recipesSearch
        }
    }
    
    //MARK: - Actions
    
    @IBAction func didTapButtonToAddIngredient(_ sender: Any) {
        guard let ingredient = searchTextField.text, !ingredient.isBlank else {
            alert(message: "write an ingredient")
            return}
        ingredients.append(ingredient)
        ingredientsTableView.reloadData()
        searchTextField.text = ""
    }
    
    @IBAction func didTapGoButton(_ sender: Any) {
        guard ingredients.count >= 1 else { return alert(message: "add an ingredient") }
        loadRecipes()
    }
    
    @IBAction func didTapClearButton(_ sender: Any) {
        // ask user if he wants to delete all ingredients
        let alertUserDelete = UIAlertController(title: "Delete All ?", message: "Are you sure you want to delete all ingredients ?", preferredStyle: .alert)
        // if ok delete all
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.ingredients.removeAll()
            self.ingredientsTableView.reloadData()
        })
        // if cancel no delete all
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        alertUserDelete.addAction(ok)
        alertUserDelete.addAction(cancel)
        self.present(alertUserDelete, animated: true, completion: nil)
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchTextField.resignFirstResponder()
    }
    
    //MARK: - Methods
    
    /// Method to call API and get data
    func loadRecipes() {
        manageActivityIndicator(activityIndicator: searchActivityController, button: searchRecipesButton, showActivityIndicator: true)
        recipesService.getRecipes(ingredients: ingredients) { result in
            DispatchQueue.main.async {
                switch result {
                case.success(let recipes):
                    self.recipesSearch = recipes
                    self.performSegue(withIdentifier: self.identifierSegue, sender: nil)
                case .failure:
                    self.alert(message:"incorrect request")
                }
                self.manageActivityIndicator(activityIndicator: self.searchActivityController, button: self.searchRecipesButton, showActivityIndicator: false)
            }
        }
    }
    
    func tap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}

//MARK: - Extension TableView

extension SearchRecipeViewController: UITableViewDataSource {
    
    // configure colums in tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //configue lines in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    // configure a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? IngredientTableViewCell else {
            return UITableViewCell()
        }
        let ingredient = ingredients[indexPath.row]
        cell.configure(ingredient: ingredient)
        return cell
    }
    // delete a row in tableView
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
