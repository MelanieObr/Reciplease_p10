//
//  ListRecipeViewController.swift
//  Reciplease_p10
//
//  Created by Mélanie Obringer on 11/12/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import UIKit

final class ListRecipeViewController: UIViewController {
    
    //MARK: - Properties
    
    var recipesSearch: RecipeSearch?
    var recipeDisplay: RecipeDisplay?
    
    //MARK: - Outlets
    
    @IBOutlet weak var recipesTableView: UITableView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipesTableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "recipeCell")
    }
    
    //MARK: - Configure segue to DetailRecipe 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "DetailRecipe" else {
            return
        }
        guard let recipesVc = segue.destination as? DetailRecipeViewController else {return}
        recipesVc.recipeDisplay = recipeDisplay
    }
}

//MARK: - TableView

extension ListRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // configure colums in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesSearch?.hits.count ?? 0
    }
    // configure cell format with RecipeTableViewCell class
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        cell.recipe = recipesSearch?.hits[indexPath.row]
        return cell
    }
    // configure message if no recipe is found
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
           let label = UILabel()
           label.text = "Not find recipes, try again !"
           label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
           label.textAlignment = .center
           label.textColor = .darkGray
           return label
       }
    //
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return recipesSearch?.hits.isEmpty ?? true ? 200 : 0
       }
    // configure height of cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    // cell selected to call in DetailRecipeViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = recipesSearch?.hits[indexPath.row]
        guard let imageUrl = recipe?.recipe.image, let yield = recipe?.recipe.yield?.convertToString(value: recipe?.recipe.yield ?? 0) else {return}
        let recipeDisplay = RecipeDisplay(label: recipe?.recipe.label ?? "", image: loadImageDataFromUrl(stringImageUrl: imageUrl), url: recipe?.recipe.url ?? "", ingredients: recipe?.recipe.ingredientLines ?? [], totalTime: recipe?.recipe.totalTime?.convertIntToTime ?? "", yield: yield)
        self.recipeDisplay = recipeDisplay
        performSegue(withIdentifier:"DetailRecipe", sender: nil)
    }
}





