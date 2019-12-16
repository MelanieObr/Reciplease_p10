//
//  IngredientTableViewCell.swift
//  Reciplease_p10
//
//  Created by Mélanie Obringer on 11/12/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
  
    
    @IBOutlet weak var ingredientLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(ingredient: String) {
        ingredientLabel.text = "- \(ingredient)"
        ingredientLabel.textColor = .white
//        ingredientLabel.font = UIFont(name: "Chalkduster", size: 20)
    }
}
