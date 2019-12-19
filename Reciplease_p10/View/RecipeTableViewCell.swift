//
//  RecipeTableViewCell.swift
//  Reciplease_p10
//
//  Created by Mélanie Obringer on 11/12/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    
    // MARK: - Properties
    
    var recipe: Hit? {
        didSet {
            titleLabel.text = recipe?.recipe.label
            guard let time = recipe?.recipe.totalTime  else {return}
            totalTimeLabel.text = time.convertIntToTime
            //            }
            guard let yield = recipe?.recipe.yield  else {return}
            if yield == 0 {
                yieldLabel.text = "NA"
            } else {
                yieldLabel.text = "\( yield)"
            }
            guard let ingredients = recipe?.recipe.ingredients[0].text else {return}
            ingredientLabel.text = ingredients
            guard let image = recipe?.recipe.image else {return}
            guard let url = URL(string: image) else {return}
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.recipeImageView.image = UIImage(data: data! as Data)
                }
            }
        }
    }
    
    var favoriteRecipe: FavoritesRecipesList? {
        didSet {
            titleLabel.text = favoriteRecipe?.name
            guard let yield =  favoriteRecipe?.yield  else {return}
            if yield == "0" {
                yieldLabel.text = "NA"
            } else {
                yieldLabel.text = "\( yield)"
            }
            guard let ingredients = favoriteRecipe?.ingredients else {return}
            ingredientLabel.text = ingredients
            if let imageData = favoriteRecipe?.image {
                recipeImageView.image = UIImage(data: imageData)
            }
            totalTimeLabel.text = favoriteRecipe?.totalTime
        }
    }
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
