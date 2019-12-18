//
//  ListRecipeViewController.swift
//  Reciplease_p10
//
//  Created by Mélanie Obringer on 11/12/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import UIKit
import Foundation

class ListRecipeViewController: UIViewController {
    
    //MARK: - Properties
    
    var recipesSearch: RecipeSearch?
    var recipeDisplay: RecipeDisplay?
    
    //MARK: - Outlets
    
    @IBOutlet weak var recipesTableView: UITableView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("***", recipesSearch)
         recipesTableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "recipeCell")
        
    }
    
    //MARK: - Configure segue to DetailRecipe controller
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "DetailRecipe" else {
            return
        }
        guard let recipesVc = segue.destination as? DetailRecipeViewController else {return}
        recipesVc.recipeDisplay = recipeDisplay
    }
}

//MARK: - extension TableView

extension ListRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // print("***", recipesSearch?.hits.count)
        return recipesSearch?.hits.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        cell.recipe = recipesSearch?.hits[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140 // the height for custom cell 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = recipesSearch?.hits[indexPath.row]
        guard let imageUrl = recipe?.recipe.image, let ingredientsArray = recipe?.recipe.ingredientLines, let yield = recipe?.recipe.yield?.convertToString(value: recipe?.recipe.yield ?? 0) else {return}
        let recipeDisplay = RecipeDisplay(label: recipe?.recipe.label ?? "", image: loadImageDataFromUrl(stringImageUrl: imageUrl), url: recipe?.recipe.url ?? "", ingredientLines: "-" + " " + ingredientsArray.joined(separator: "\n\n" + "-" + " "), totalTime: recipe?.recipe.totalTime?.convertIntToTime ?? "", yield: yield)
        self.recipeDisplay = recipeDisplay
        performSegue(withIdentifier:"DetailRecipe", sender: nil)
    }
}





